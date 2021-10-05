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
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.Compute;
using Microsoft.Azure.Management.Compute.Models;
using Microsoft.Azure.Management.Network;
using NetworkManagementClient = Microsoft.Azure.Management.Network.NetworkManagementClient;

namespace FTDAutoScaleManager
{
    //***************************************Scale Out*****************************************************************
    public static class FtdScaleOut
    {
        [FunctionName("FtdScaleOut")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            int operationDelay = 60000; //1min
            var resoureGroupName = System.Environment.GetEnvironmentVariable("RESOURCE_GROUP_NAME", EnvironmentVariableTarget.Process);
            var vmScalesetName = System.Environment.GetEnvironmentVariable("VMSS_NAME", EnvironmentVariableTarget.Process);
            var subscriptionId = System.Environment.GetEnvironmentVariable("SUBSCRIPTION_ID", EnvironmentVariableTarget.Process);

            string COUNT = req.Query["COUNT"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            COUNT = COUNT ?? data?.COUNT;

            int ftdCountInt = Convert.ToInt32(COUNT);
            log.LogWarning("FtdScaleOut:::: count str {0}, count int {1}", COUNT, ftdCountInt);
            log.LogWarning("FtdScaleOut:::: FTD ScaleOut Started (RG : {0}, VMSS: {1}, Count: {2})", resoureGroupName.ToString(), vmScalesetName.ToString(), ftdCountInt);

            var factory = new AzureCredentialsFactory();
            var msiCred = factory.FromMSI(new MSILoginInformation(MSIResourceType.AppService), AzureEnvironment.AzureGlobalCloud);
            var azure = Azure.Configure().WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic).Authenticate(msiCred).WithSubscription(subscriptionId);
            var vMachineScaleSet = azure.VirtualMachineScaleSets.GetByResourceGroup(resoureGroupName, vmScalesetName);

            log.LogWarning("FtdScaleOut:::: Current VMSS Capacity : {0}", vMachineScaleSet.Capacity.ToString());
            var computeManagementClient = new ComputeManagementClient(msiCred) { SubscriptionId = azure.SubscriptionId };
            var update = computeManagementClient.VirtualMachineScaleSets.CreateOrUpdateWithHttpMessagesAsync(resoureGroupName, vmScalesetName,
                    new VirtualMachineScaleSet
                    {
                        Location = vMachineScaleSet.RegionName,
                        Overprovision = false,
                        Sku = new Sku
                        {
                            Capacity = vMachineScaleSet.Capacity + ftdCountInt,
                            Name = vMachineScaleSet.Sku.Sku.Name,
                            Tier = vMachineScaleSet.Sku.Sku.Tier
                        }
                    });
            log.LogInformation("FtdScaleOut:::: FTD Scale Out Started... Please wait");
            update.Wait(operationDelay);
            log.LogInformation("FtdScaleOut:::: FTD Scale Out Status : {0}", update.Status.ToString());

            if ("WaitingForActivation" != update.Status.ToString())
            {
                log.LogError("FtdScaleOut:::: ScaleOut Operation failed (Status : {0})", update.Status.ToString());
                return (ActionResult)new BadRequestObjectResult("ERROR: ScaleOut Operation failed");
            }

            vMachineScaleSet = azure.VirtualMachineScaleSets.GetByResourceGroup(resoureGroupName, vmScalesetName);
            log.LogWarning("FtdScaleOut:::: Post ScaleOut VMSS Capacity : {0}", vMachineScaleSet.Capacity.ToString());
            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }

    //***************************************Scale-In*****************************************************************
    public static class FtdScaleIn
    {
        [FunctionName("FtdScaleIn")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            int operationDelay = 90000; //1.5min
            var resoureGroupName = System.Environment.GetEnvironmentVariable("RESOURCE_GROUP_NAME", EnvironmentVariableTarget.Process);
            var vmScalesetName = System.Environment.GetEnvironmentVariable("VMSS_NAME", EnvironmentVariableTarget.Process);
            var subscriptionId = System.Environment.GetEnvironmentVariable("SUBSCRIPTION_ID", EnvironmentVariableTarget.Process);
            string instanceid = req.Query["instanceid"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            instanceid = instanceid ?? data?.instanceid;
            int vmssCapacity = 0;
 
            if (null == instanceid)
            {
                log.LogError("FtdScaleIn:::: Invalid FTD Instance Id for ScaleIn");
                return (ActionResult)new BadRequestObjectResult("ERROR: Invalid FTD Instance Id for ScaleIn");
            }

            log.LogWarning("FtdScaleIn:::: FTD Scale-In Started (RG : {0}, VMSS: {1}, FTD InstanceId to Delete: {2} )", resoureGroupName.ToString(), vmScalesetName.ToString(), instanceid);

            var factory = new AzureCredentialsFactory();
            var msiCred = factory.FromMSI(new MSILoginInformation(MSIResourceType.AppService), AzureEnvironment.AzureGlobalCloud);
            var azure = Azure.Configure().WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic).Authenticate(msiCred).WithSubscription(subscriptionId);
            var vMachineScaleSet = azure.VirtualMachineScaleSets.GetByResourceGroup(resoureGroupName, vmScalesetName);

            vmssCapacity = vMachineScaleSet.Capacity;
            log.LogInformation("FtdScaleIn:::: Current VMSS Capacity : {0}", vmssCapacity);

            var computeManagementClient = new ComputeManagementClient(msiCred) { SubscriptionId = azure.SubscriptionId };
            //var del = computeManagementClient.VirtualMachineScaleSetVMs.DeleteWithHttpMessagesAsync(resoureGroupName, vmScalesetName, instanceid).Result;
            var del = computeManagementClient.VirtualMachineScaleSetVMs.DeleteWithHttpMessagesAsync(resoureGroupName, vmScalesetName, instanceid);
            del.Wait(operationDelay);

            vMachineScaleSet = azure.VirtualMachineScaleSets.GetByResourceGroup(resoureGroupName, vmScalesetName);
            log.LogInformation("FtdScaleIn:::: Post ScaleIn VMSS Capacity : {0}", vMachineScaleSet.Capacity.ToString());

            if ((vmssCapacity - 1) != vMachineScaleSet.Capacity)
            {
                log.LogError("FtdScaleIn:::: Failed ScaleIn Operation (vmss capacity: {0})", vMachineScaleSet.Capacity);
                return (ActionResult)new BadRequestObjectResult("ERROR: Failed ScaleIn Operation. Don't worry, Azure may be taking longer time to delete, but eventually it may delete");
            }
            
            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }

    //***************************************Get Public IP of new FTD*****************************************************************
    public static class FtdGetPubIp
    {
        [FunctionName("GetFtdPublicIp")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            var subscriptionId = System.Environment.GetEnvironmentVariable("SUBSCRIPTION_ID", EnvironmentVariableTarget.Process);
            string COUNT = req.Query["COUNT"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            COUNT = COUNT ?? data?.COUNT;

            string TYPE = req.Query["TYPE"];
            string requestBody1 = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data1 = JsonConvert.DeserializeObject(requestBody);
            TYPE = TYPE ?? data?.TYPE;

            int ftdCountInt = Convert.ToInt32(COUNT);
            int index = 1;

            if("REGULAR" == TYPE)
            {
                log.LogWarning("GetFtdPublicIp:::: This is regular scale-out ");
            }
            else if("INIT" == TYPE)
            {
                log.LogWarning("GetFtdPublicIp:::: This is initial deployment");
            }
            else
            {
                return (ActionResult)new BadRequestObjectResult("ERROR: Invalid request TYPE");
            }
            var resoureGroupName = System.Environment.GetEnvironmentVariable("RESOURCE_GROUP_NAME", EnvironmentVariableTarget.Process);
            var vmScalesetName = System.Environment.GetEnvironmentVariable("VMSS_NAME", EnvironmentVariableTarget.Process);
            var networkInterfaceName = System.Environment.GetEnvironmentVariable("MNGT_NET_INTERFACE_NAME", EnvironmentVariableTarget.Process);
            var ipConfigurationName = System.Environment.GetEnvironmentVariable("MNGT_IP_CONFIG_NAME", EnvironmentVariableTarget.Process);
            var publicIpAddressName = System.Environment.GetEnvironmentVariable("MNGT_PUBLIC_IP_NAME", EnvironmentVariableTarget.Process);

            log.LogWarning("GetFtdPublicIp:::: Getting Public IP of new FTD (RG : {0}, VMSS: {1} )", resoureGroupName.ToString(), vmScalesetName.ToString());
            log.LogInformation("GetFtdPublicIp:::: Network Interface name : {0}, IP Configuration Name : {1}, Public IP Address Name : {2}", networkInterfaceName, ipConfigurationName, publicIpAddressName);

            var factory = new AzureCredentialsFactory();
            var msiCred = factory.FromMSI(new MSILoginInformation(MSIResourceType.AppService), AzureEnvironment.AzureGlobalCloud);
            var azure = Azure.Configure().WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic).Authenticate(msiCred).WithSubscription(subscriptionId);

            var NmClient = new NetworkManagementClient(msiCred) { SubscriptionId = azure.SubscriptionId };
            var interfaceList = NmClient.NetworkInterfaces.ListVirtualMachineScaleSetNetworkInterfaces(resoureGroupName, vmScalesetName);
            string vmindex = "";
            string tmpVmindex = "";
            int intVmindex = 0;
            var vmlist = azure.VirtualMachineScaleSets.GetByResourceGroup(resoureGroupName, vmScalesetName);
            var vmStatus = "";
            var tmpVmName = "ERROR";

            //ToDo: This logic should be simplified by only using VMSS list, netInterface is not needed 
            foreach (var netInterface in interfaceList)
            {
                if (netInterface.IpConfigurations[0].PublicIPAddress != null)
                {
                    var tmpIntfName = netInterface.IpConfigurations[0].PublicIPAddress.Id.Split('/').GetValue(12);
                    var tmpConfigName = netInterface.IpConfigurations[0].PublicIPAddress.Id.Split('/').GetValue(14);
                    var tmpPubIpName = netInterface.IpConfigurations[0].PublicIPAddress.Id.Split('/').GetValue(16);

                    if ((tmpIntfName.ToString() == networkInterfaceName) && (tmpConfigName.ToString() == ipConfigurationName) && (tmpPubIpName.ToString() == publicIpAddressName))
                    {
                        vmindex = netInterface.IpConfigurations[0].PublicIPAddress.Id.Split('/').GetValue(10).ToString();
                        //Azure bug: Azure sometimes retains old deleted VMs in its list for very long time, need to avoid those instances
                        vmStatus = "ON";
                        foreach (var vm in vmlist.VirtualMachines.List())
                        {
                            if (vm.InstanceId == vmindex)
                            {
                                if (null == vm.PowerState)
                                {
                                    vmStatus = "OFF";
                                }
                                if (null != vm.Name)
                                {
                                    tmpVmName = vm.Name;
                                }
                                break;
                            }
                        }
                        if ("OFF" == vmStatus)
                        {
                            log.LogError("GetFtdPublicIp:::: VM index :{0} is in unknown state..skip", vmindex);
                            continue;
                        }
                        //Azure bug: some times even deleted VMs are still attahed to network interfaces for very long time
                        if ("ERROR" == tmpVmName)
                        {
                            log.LogError("GetFtdPublicIp:::: VM index :{0} VM name not found...skip", vmindex);
                            continue;
                        }

                        if ("INIT" == TYPE)
                        {
                            if (index == ftdCountInt)
                            {
                                //index >100 is just to safegaurd this loop..its has no other logic
                                break;
                            }
                            index++;
                        }
                        else
                        {
                            //Azure bug: Some time it will mix indexes and does not preserve sequence
                            if (Convert.ToInt32(vmindex) < intVmindex)
                            {
                                log.LogWarning("GetFtdPublicIp:::: Azure index jumbling detected");
                                vmindex = intVmindex.ToString();
                            }
                            else
                            {                                
                                intVmindex = Convert.ToInt32(vmindex);
                                log.LogInformation("GetFtdPublicIp:::: Assigning vmindex = {0}", vmindex);
                            }

                        }
                    }
                }
            }
            // EJK modification begin
            string fmcIpType = System.Environment.GetEnvironmentVariable("FMC_IP_TYPE", EnvironmentVariableTarget.Process);
            var publicIp = "NotUsed";
            if (fmcIpType != "private")
            {
                publicIp = NmClient.PublicIPAddresses.GetVirtualMachineScaleSetPublicIPAddress(resoureGroupName, vmScalesetName, vmindex, networkInterfaceName, ipConfigurationName, publicIpAddressName).IpAddress;
                if (null == publicIp)
                {
                    log.LogError("GetFtdPublicIp:::: Unable to get Public IP of new FTD (index {0}", vmindex);
                    return (ActionResult)new BadRequestObjectResult("ERROR: Unable to get Public IP of new FTD");
                }
                log.LogInformation("GetFtdPublicIp:::: Public IP of New FTD (VM index {0}) = {1}", vmindex, publicIp);
            }
            // EJK modification end
            //find VM name from index
            string vmname = "";
            string privateIp = "";
            var vmss = azure.VirtualMachineScaleSets.GetByResourceGroup(resoureGroupName, vmScalesetName);
            foreach (var vm in vmss.VirtualMachines.List())
            {
                if(vm.InstanceId == vmindex)
                {
                    vmname = vm.Name;
                    foreach(var netintf in vm.ListNetworkInterfaces())
                    {
                        privateIp = netintf.PrimaryPrivateIP;
                        break;
                    }
                    break;
                }
            }
            // EJK modification begin
            var communicationIp = publicIp;
            if (fmcIpType == "private")
            {
                communicationIp = privateIp;
            }
            var commandStr = "{ \"ftdDevName\": \"" + vmname + "\", \"ftdPublicIp\": \"" + communicationIp + "\", \"ftdPrivateIp\" : \"" + privateIp + "\"  }";
            return (ActionResult)new OkObjectResult(commandStr);
           // EJK modification end
        }
    }
}