//  Copyright (c) 2020 Cisco Systems Inc or its affiliates.
//
//  All Rights Reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Rest.Azure.OData;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.Monitor;
using Microsoft.Azure.Management.Monitor.Models;
using Microsoft.Azure.Management.Network;
using NetworkManagementClient = Microsoft.Azure.Management.Network.NetworkManagementClient;
using fmcAuth;
using getDevIdByName;
using getFtdMetricsFromFmc;

using getDevIdByName;
using RestSharp;
using RestClient = RestSharp.RestClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

/* Scaling Logic:-
 * If current Scale set capacity = 0, Start Scale-Out (increase VM count by 1 or by 'MIN_FTD_COUNT' duration based on 'INITIAL_DEPLOYMENT_MODE'
 * POLICY-1 :  ScaleOut : If any VM's average usage goes beyond 'SCALE_OUT_THRESHLD' for 'SAMPLING_TIME_MIN' duration and current scale set capacity < 'MAX_FTD_COUNT'
 * POLICY-2 :  ScaleOut : If average usage of scaling group goes beyond 'SCALE_OUT_THRESHLD' for 'SAMPLING_TIME_MIN' duration and current scale set capacity < 'MAX_FTD_COUNT'
 * Scale-In :  If all the VM's average usage goes below 'SCALE_IN_THRESHLD' for 'SAMPLING_TIME_MIN' duration and current scale set capacity > 'MIN_FTD_COUNT'
 */

namespace FTDAutoScaleManager
{
    public static class AutoScaleManager
    {
        [FunctionName("AutoScaleManager")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
           
            log.LogWarning("AutoScaleManager:::: Task to check Scaling requirement.. Started (ASM Version : V3.1)");
            var subscriptionId = System.Environment.GetEnvironmentVariable("SUBSCRIPTION_ID", EnvironmentVariableTarget.Process);
            var resoureGroupName = System.Environment.GetEnvironmentVariable("RESOURCE_GROUP_NAME", EnvironmentVariableTarget.Process);
            var vmScalesetName = System.Environment.GetEnvironmentVariable("VMSS_NAME", EnvironmentVariableTarget.Process);
            var minFTDCountStr = System.Environment.GetEnvironmentVariable("MIN_FTD_COUNT", EnvironmentVariableTarget.Process);
            var maxFTDCountStr = System.Environment.GetEnvironmentVariable("MAX_FTD_COUNT", EnvironmentVariableTarget.Process);
            var sampleTimeMin = System.Environment.GetEnvironmentVariable("SAMPLING_TIME_MIN", EnvironmentVariableTarget.Process);
            var scaleOutThresholdCpuStr = System.Environment.GetEnvironmentVariable("SCALE_OUT_THRESHLD_CPU", EnvironmentVariableTarget.Process);
            var scaleInThresholdCpuStr = System.Environment.GetEnvironmentVariable("SCALE_IN_THRESHLD_CPU", EnvironmentVariableTarget.Process);
            var scaleOutThresholdMemStr = System.Environment.GetEnvironmentVariable("SCALE_OUT_THRESHLD_MEM", EnvironmentVariableTarget.Process);
            var scaleInThresholdMemStr = System.Environment.GetEnvironmentVariable("SCALE_IN_THRESHLD_MEM", EnvironmentVariableTarget.Process);
            var initialDeployMethod = System.Environment.GetEnvironmentVariable("INITIAL_DEPLOYMENT_MODE", EnvironmentVariableTarget.Process); //supported STEP / BULK
            var scalingPolicy = System.Environment.GetEnvironmentVariable("SCALING_POLICY", EnvironmentVariableTarget.Process); // POLICY-1 / POLICY-2
            var metrics = System.Environment.GetEnvironmentVariable("SCALING_METRICS_LIST", EnvironmentVariableTarget.Process).ToLower();

            int minFTDCount = Convert.ToInt32(minFTDCountStr);
            int maxFTDCount = Convert.ToInt32(maxFTDCountStr);
            double scaleOutThresholdCpu = Convert.ToDouble(scaleOutThresholdCpuStr);
            double scaleInThresholdCpu = Convert.ToDouble(scaleInThresholdCpuStr);
            double scaleOutThresholdMem = Convert.ToDouble(scaleOutThresholdMemStr);
            double scaleInThresholdMem = Convert.ToDouble(scaleInThresholdMemStr);
            int currentVmCapacity = 0;
            string scaleStr = "";

            log.LogInformation("CPU Scale Out threshold: {0}%, Scale In threshold : {1}%", scaleOutThresholdCpu, scaleInThresholdCpu);
           // log.LogInformation("Memory Scale Out threshold: {0}%, Scale In threshold : {1}%", scaleOutThresholdMem, scaleInThresholdMem);

            //Reject if CPU scale Out Threshold < scale In Threshold
            if (scaleOutThresholdCpu <= scaleInThresholdCpu)
            {
                log.LogError("AutoScaleManager:::: CPU metrics ScaleOut Threshold ({0}) is less than or equal to ScaleIn Threshold ({1}) this is not correct", scaleOutThresholdCpu, scaleInThresholdCpu);
                return (ActionResult)new BadRequestObjectResult("ERROR: CPU Metrics ScaleOut threshold is less than or equal to ScaleIn threshold");
            }

            //Validate Metrics
            if(  (!metrics.Contains("cpu")) && (!metrics.Contains("memory")))
            {
                log.LogError("AutoScaleManager:::: Invalid metrics specified : {0} (valid metrics are CPU or CPU, Memory)", metrics);
                return (ActionResult)new BadRequestObjectResult("ERROR: Invalid Metrics..Can not continue");
            }


            //Check FMC connection, If we can not connect to FMC do not continue
            log.LogInformation("AutoScaleManager:::: Checking FMC connection");

            var getAuth = new fmcAuthClass();
            string authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("AutoScaleManager:::: Failed to connect to FMC..Can not continue");
                return (ActionResult)new BadRequestObjectResult("ERROR: Failed to connet to FMC..Can not continue");
            }

            log.LogInformation("AutoScaleManager:::: Sampling Resource Utilization at {0}min Average", sampleTimeMin);

            var factory = new AzureCredentialsFactory();
            var msiCred = factory.FromMSI(new MSILoginInformation(MSIResourceType.AppService), AzureEnvironment.AzureGlobalCloud);
            var azure = Azure.Configure().WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic).Authenticate(msiCred).WithSubscription(subscriptionId);

            string resourceUri = null;
            var vmss = azure.VirtualMachineScaleSets.GetByResourceGroup(resoureGroupName, vmScalesetName);
            resourceUri = vmss.Id;

            if (null == resourceUri)
            {
                log.LogError("AutoScaleManager:::: Unable to get resource uri");
                return (ActionResult)new BadRequestObjectResult("ERROR: Unable to get resource uri");
            }

            currentVmCapacity = vmss.Capacity;
            log.LogWarning("AutoScaleManager:::: Current capacity of VMSS : {0}", currentVmCapacity);

            //If the VMSS capacity is '0' consider this as first deployment and spawn 'minimum FTD count' at a time
            if(( 0 == currentVmCapacity ) && (0 != minFTDCount))
            {
                log.LogWarning("AutoScaleManager:::: Current VMSS capacity is 0, considering it as first deployment (min FTD count needed : {0}", minFTDCount);
                if("BULK" == initialDeployMethod)
                {
                    log.LogWarning("AutoScaleManager:::: Selected initial deployment mode is BULK");
                    log.LogWarning("AutoScaleManager:::: Deploying {0} number of FTDvs in scale set", minFTDCount);
                    scaleStr = "{ \"COMMAND\": \"SCALEOUT\", \"COUNT\": \"" + minFTDCount + "\", \"TYPE\": \"INIT\" }";
                    return (ActionResult)new OkObjectResult(scaleStr);

                }
                else
                {
                    log.LogWarning("AutoScaleManager:::: BULK method is not selected for initial deployment.. proceeding with STEP");
                    scaleStr = "{ \"COMMAND\": \"SCALEOUT\", \"COUNT\": \"1\", \"TYPE\": \"REGULAR\"}";
                    return (ActionResult)new OkObjectResult(scaleStr);
                }
            }

            //If current capacity is less than minimum FTD count requied then we need to scale-out
            if (currentVmCapacity < minFTDCount)
            {
                log.LogWarning("AutoScaleManager:::: Current VMSS Capacity({0}) is less than minimum FTD count ({1}) needed.. time to SCALE-OUT", currentVmCapacity, minFTDCount);
                scaleStr = "{ \"COMMAND\": \"SCALEOUT\", \"COUNT\": \"1\", \"TYPE\": \"REGULAR\"}";
                return (ActionResult)new OkObjectResult(scaleStr);
            }


            //-------------------------------------------------Scaling decission based on Metrics------------------------------------------------------
            log.LogWarning("AutoScaleManager:::: Scaling Policy : {0}", scalingPolicy);

            var sampleIntervalMin = System.TimeSpan.FromMinutes(Convert.ToDouble(sampleTimeMin));
            MonitorManagementClient metricClient = new MonitorManagementClient(msiCred);
            double ftdCpuUsage = 0;
            double groupCpuUsage = 0;
            double consolidatedCpuUsage = 0;
            bool scaleInRejectFlag = false;
            double minFtdCpuUsage = 9999;
            string leastCpuLoadedFtd = "";
            string leastCpuLoadedFtdIndex = "";
            bool memoryMetricsEnabled = false;

            double ftdMemUsage = 0;
            double groupMemUsage = 0;
            double consolidatedMemUsage = 0;
            string ftdNameWithHighMemUtilization = "";

            //Get FTD's Memory if 'Memory' metrics is enabled
            if (metrics.Contains("memory"))
            {
                memoryMetricsEnabled = true;
                log.LogInformation("Memory metrics enabled");
                log.LogInformation("Memory Scale Out threshold: {0}%, Scale In threshold : {1}%", scaleOutThresholdMem, scaleInThresholdMem);

                //Reject if Memory scale Out Threshold < scale In Threshold
                if (scaleOutThresholdMem <= scaleInThresholdMem)
                {
                    log.LogError("AutoScaleManager:::: Memory metrics ScaleOut Threshold ({0}) is less than or equal to ScaleIn Threshold ({1}) this is not correct", scaleOutThresholdMem, scaleInThresholdMem);
                    return (ActionResult)new BadRequestObjectResult("ERROR: Memory Metrics ScaleOut threshold is less than or equal to ScaleIn threshold");
                }

                var getMetrics = new getMetricsClass();
                var getId = new getDevIdByNameClass();
                var devIds = getId.getAllDevId(authToken, log);
                if("ERROR" == devIds)
                {
                    log.LogError("AutoScaleManager::::Unable to get device IDs");
                    return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                }
                //parse json object
                JObject o = JObject.Parse(devIds);

                foreach (var vm in vmss.VirtualMachines.List())
                {
                    var vmName = vm.Name.ToString();
                    var devId = "";
                    try
                    {
                        foreach (var item in o["items"])
                        {
                            if (vmName == item["name"].ToString())
                            {
                                devId = item["id"].ToString();
                                break;
                            }
                        }
                        if (0 == devId.Length)
                        {
                            log.LogError("AutoScaleManager:::: Unable to get Device ID for Device Name({0})", vmName);
                            return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                        }
                    }
                    catch
                    {
                        log.LogError("AutoScaleManager:::: Exception Occoured while parsing device id response");
                        return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                    }
                   
                    ftdMemUsage = Convert.ToDouble(getMetrics.getFtdMemoryMetrics(devId, authToken, log));
                    if(-1 == ftdMemUsage)
                    {
                        log.LogError("AutoScaleManager:::: Failed to get Memory usage of {0}", vmName);
                        return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                    }
                    if (ftdMemUsage > scaleInThresholdMem)
                    {
                        //No need to Scale-In
                        scaleInRejectFlag = true;
                    }
                    log.LogInformation("AutoScaleManager:::: Memory usage of {0} is {1} %", vmName, ftdMemUsage);
                    if ("POLICY-1" == scalingPolicy)
                    {
                        if (ftdMemUsage > scaleOutThresholdMem)
                        {
                            log.LogWarning("AutoScaleManager:::: FTD {0} has Memory Utilization of {1} % which is greater than Scale Out threshold", vmName, ftdMemUsage);
                            ftdNameWithHighMemUtilization = vmName;
                            break;
                        }
                    }
                    else if ("POLICY-2" == scalingPolicy)
                    {
                        groupMemUsage += ftdMemUsage;
                    }
                }
                groupMemUsage /= vmss.Capacity;
                if ("POLICY-2" == scalingPolicy)
                {
                    log.LogInformation("AutoScaleManager:::: Group Memory average usage : {0} %", groupMemUsage);
                }
            }
            else
            {
                //Memory metrics not enabled, reset thresholds 
                scaleOutThresholdMem = 0;
            }

            
            if("POLICY-2" == scalingPolicy)
            {
                log.LogInformation("AutoScaleManager:::: Scaling Policy-2 Selected..Getting average CPU utilization of scale set");
                var response = await metricClient.Metrics.ListAsync(resourceUri, null, null, sampleIntervalMin, "Percentage CPU", "Average");
                foreach (var metric in response.Value)
                {
                    foreach (var series in metric.Timeseries)
                    {
                        foreach (var point in series.Data)
                        {
                            if (point.Average.HasValue)
                            {
                                groupCpuUsage = point.Average.Value;
                                log.LogDebug("AutoScaleManager:::: avg cpu: {0}", groupCpuUsage);
                            }
                        }
                    }
                }
                log.LogInformation("AutoScaleManager:::: Group CPU average usage : {0} %", groupCpuUsage);                
            }

            foreach (var vm in vmss.VirtualMachines.List())
            {
                var vmName = vm.Name;                
                ftdCpuUsage = 0;
                //Metrics filter
                ODataQuery<MetadataValue> odataFilterMetrics = new ODataQuery<MetadataValue>(string.Format("VMName eq '{0}'", vmName));

               // log.LogInformation("AutoScaleManager:::: Getting Metrics for : {0}", vmName);
                var response = await metricClient.Metrics.ListAsync(resourceUri, odataFilterMetrics, null, sampleIntervalMin, "Percentage CPU", "Average");

                foreach (var metric in response.Value)
                {
                    foreach (var series in metric.Timeseries)
                    {
                        foreach (var point in series.Data)
                        {
                            if (point.Average.HasValue)
                            {
                                 ftdCpuUsage = point.Average.Value;
                                 log.LogDebug("AutoScaleManager:::: avg cpu: {0}", ftdCpuUsage);
                            }
                        }
                    }
                }

                log.LogInformation("AutoScaleManager:::: Avg CPU Utilizatio of VM({0}) in last {1}min : {2}%", vmName, sampleTimeMin, ftdCpuUsage);

                //Maintain the FTD with minimum utilization to scale-in if needed
                if(ftdCpuUsage < minFtdCpuUsage)
                {
                    minFtdCpuUsage = ftdCpuUsage;
                    leastCpuLoadedFtd = vmName;
                    leastCpuLoadedFtdIndex = vm.InstanceId;
                }

                if ("POLICY-1" == scalingPolicy)
                {
                    //Average usage of individual Instance
                    consolidatedCpuUsage = ftdCpuUsage;
                    consolidatedMemUsage = ftdMemUsage;
                }
                else if ("POLICY-2" == scalingPolicy)
                {
                    //Scale Set average utilization
                    consolidatedCpuUsage = groupCpuUsage;
                    consolidatedMemUsage = groupMemUsage;
                }
                else
                {
                    log.LogError("AutoScaleManager:::: Invalid Scaling Policy {0}", scalingPolicy);
                    return (ActionResult)new BadRequestObjectResult("ERROR: Invalid Scaling Policy");
                }

                //If CPU utilization is greater than scale-out threshold then Scale-Out
                //Note: if memory metrics is not enabled then consolidatedMemUsage will be always 0
                if ((consolidatedCpuUsage > scaleOutThresholdCpu) || (consolidatedMemUsage > scaleOutThresholdMem))
                {
                    //If current capacity is equal to max FTD count required then do nothing
                    //If current capacity is more than max FTD count (This should never happen) do nothing
                    if (currentVmCapacity >= maxFTDCount)
                    {
                        log.LogWarning("AutoScaleManager:::: Current VMSS Capacity({0}) is greater than or equal to max FTD count ({1}) needed.. No action needed", currentVmCapacity, maxFTDCount);
                        return (ActionResult)new OkObjectResult("NOACTION");
                    }
                    if ("POLICY-1" == scalingPolicy)
                    {
                        log.LogWarning("AutoScaleManager:::: Avg CPU Utilizatio of VM({0}) in last {1}min is {2}% ", vmName, sampleTimeMin, consolidatedCpuUsage);
                        if (memoryMetricsEnabled && (consolidatedMemUsage > scaleOutThresholdMem))
                        {
                            log.LogWarning("AutoScaleManager:::: Avg Memory Utilizatio of VM({0}) is {1}% ", ftdNameWithHighMemUtilization, consolidatedMemUsage);
                        }
                        log.LogWarning("AutoScaleManager:::: Time to SCALE OUT");
                    }
                    else if ("POLICY-2" == scalingPolicy)
                    {
                        log.LogWarning("AutoScaleManager:::: Avg CPU Utilizatio of Scale Set in last {0}min is {1}% ",  sampleTimeMin, consolidatedCpuUsage);
                        if (memoryMetricsEnabled)
                        {
                            log.LogWarning("AutoScaleManager:::: Avg Memory Utilizatio of Scale Set is {0}% ", consolidatedMemUsage);
                        }
                        log.LogWarning("AutoScaleManager:::: Average resource utilization of scale set is more than Scale Out threshold.. Time to SCALE OUT");
                    }
                    scaleStr = "{ \"COMMAND\": \"SCALEOUT\", \"COUNT\": \"1\", \"TYPE\": \"REGULAR\" }";
                    return (ActionResult)new OkObjectResult(scaleStr);
                }
                //If any VM's CPU utilization is greater than scale-in threshold then Scale-In is not needed
                else if (ftdCpuUsage > scaleInThresholdCpu)
                {
                    scaleInRejectFlag = true;
                }
            }

            //if scaleInRejectFlag is not set, it means all the VM's CPU & Memory utilization is less than or equal to Scale-In threshold
            //Hence considering only least CPU consuming FTDv for Scale-In operation
            if (false == scaleInRejectFlag)
            {
                //If current capacity is less than or equal to minimum FTD count requied then scale-in should not be done
                if (currentVmCapacity <= minFTDCount)
                {
                    log.LogWarning("AutoScaleManager:::: Scale-In needed but Current VMSS Capacity({0}) is less than or equal to minimum FTD count ({1}) needed.. No Action done", currentVmCapacity, minFTDCount);
                    return (ActionResult)new OkObjectResult("NOACTION");
                }
                var networkInterfaceName = System.Environment.GetEnvironmentVariable("MNGT_NET_INTERFACE_NAME", EnvironmentVariableTarget.Process);
                var ipConfigurationName = System.Environment.GetEnvironmentVariable("MNGT_IP_CONFIG_NAME", EnvironmentVariableTarget.Process);
                var publicIpAddressName = System.Environment.GetEnvironmentVariable("MNGT_PUBLIC_IP_NAME", EnvironmentVariableTarget.Process);

                var NmClient = new NetworkManagementClient(msiCred) { SubscriptionId = azure.SubscriptionId };
                var publicIp = NmClient.PublicIPAddresses.GetVirtualMachineScaleSetPublicIPAddress(resoureGroupName, vmScalesetName, leastCpuLoadedFtdIndex, networkInterfaceName, ipConfigurationName, publicIpAddressName).IpAddress;

                log.LogWarning("AutoScaleManager:::: CPU Utilization of all the FTD's is less than or equal to CPU Scale-In threshold({0}%).. Time to SCALE-IN", scaleInThresholdCpu);
                if (memoryMetricsEnabled)
                {
                    log.LogWarning("AutoScaleManager:::: Memory Utilization of all the FTD's is less than or equal to Memory Scale-In threshold({0}%).. Time to SCALE-IN", scaleInThresholdMem);
                }
                log.LogWarning("AutoScaleManager:::: Least loaded FTD is : {0} with Utilization : {1}%", leastCpuLoadedFtd, minFtdCpuUsage);
                scaleStr = "{ \"COMMAND\": \"SCALEIN\", \"ftdDevName\": \"" + leastCpuLoadedFtd + "\", \"ftdPublicIp\": \"" + publicIp + "\", \"instanceid\" : \"" + leastCpuLoadedFtdIndex + "\"  }";
            
                return (ActionResult)new OkObjectResult(scaleStr);
            }
            //Scaling not needed
            log.LogWarning("AutoScaleManager:::: FTD scaleset utilization is within threshold.. no action needed");
            return (ActionResult)new OkObjectResult("NOACTION");
        }
    }
}
