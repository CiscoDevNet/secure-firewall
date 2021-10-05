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
using Newtonsoft.Json.Linq;
using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Core;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.Azure.Management.Compute;
using RestSharp;
using RestClient = RestSharp.RestClient;
//Custom classes for FMC communication
using fmcAuth;
using getDevIdByName;
using fmcRestApi;
using fmcObject;
using ftdSshClient;

//For remote ssh to FTDv..not used now
//using Renci.SshNet;
//using Renci.SshNet.Security;
//using key = Renci.SshNet.Security.KeyExchange;

namespace FTDAutoScaleManager
{
    //****************************************Register FTD with FMC*******************************************************************************
    public static class DeviceRegister
    {
        [FunctionName("DeviceRegister")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            //Get from input from env
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);
            string policyName = System.Environment.GetEnvironmentVariable("POLICY_NAME", EnvironmentVariableTarget.Process);
            string regKey = System.Environment.GetEnvironmentVariable("REG_KEY", EnvironmentVariableTarget.Process);
            string natId = System.Environment.GetEnvironmentVariable("NAT_ID", EnvironmentVariableTarget.Process);
            string devGroupName = System.Environment.GetEnvironmentVariable("DEVICE_GROUP_NAME", EnvironmentVariableTarget.Process);
            string license = System.Environment.GetEnvironmentVariable("LICENSE_CAPABILITY", EnvironmentVariableTarget.Process);

            //sameer changes
            string performanceTier = System.Environment.GetEnvironmentVariable("PERFORMANCE_TIER", EnvironmentVariableTarget.Process);

            //get input from http request
            string ftdPublicIp = req.Query["ftdPublicIp"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdPublicIp = ftdPublicIp ?? data?.ftdPublicIp;
            string ftdDevName = req.Query["ftdDevName"];
            string requestBodyName = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic dataName = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;

            string authToken = "";
            string policyId = "";

            //FMC URLs for REST API's
            var fmcPolicyUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/policy/accesspolicies";
            var fmcRegistrationUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devices/devicerecords";

            log.LogWarning("DeviceRegister:::: Received Request to Register FTD with FMC");
            log.LogInformation("DeviceRegister:::: FTD Public IP : {0}", ftdPublicIp);
            log.LogInformation("DeviceRegister:::: FTD Instance Name : {0}", ftdDevName);
            log.LogInformation("DeviceRegister:::: FMC IP : {0}", fmcIP);
            log.LogInformation("DeviceRegister:::: Policy Name : {0}", policyName);

            //------------Get authentication token------------------------------------------
            log.LogInformation("DeviceRegister:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("DeviceRegister:::: Failed to get Auth token");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth token");
            }
            log.LogInformation("DeviceRegister:::: Successfully got Auth Token with length:{0}", authToken.Length);

            //---------------------------Get Policy ID by name------------------------------------------
            log.LogInformation("DeviceRegister:::: Getting Access policy ID");

            var policyClient = new RestClient(fmcPolicyUrl);
            var policyRequest = new RestRequest(Method.GET);

            //Disable SSL certificate check
            policyClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;
            policyRequest.AddHeader("X-auth-access-token", authToken);
            var response = policyClient.Execute(policyRequest);
            if (response.StatusCode.ToString() != "OK")
            {
                log.LogError("DeviceRegister:::: Failed get Policy ID (Status Code : {0}", response.StatusCode);
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR : Failed get Policy ID");
            }
            log.LogInformation("DeviceRegister:::: Successfully got Response for policy id request ");
            log.LogDebug("DeviceRegister:::: response : {0}", response.Content);

            //convert string to json object
            try
            {
                JObject o = JObject.Parse(response.Content);
                foreach (var item in o["items"])
                {
                    if (policyName == item["name"].ToString())
                    {
                        policyId = item["id"].ToString();
                        break;
                    }
                }

                if (0 == policyId.Length)
                {
                    log.LogError("DeviceRegister:::: Unable to get Policy ID from Policy Name({0})", policyName);
                    log.LogError("DeviceRegister:::: Contents received from FMC : {0}", response.Content);
                    return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                    // return (ActionResult)new BadRequestObjectResult("ERROR: Unable to get Policy ID from Policy Name");
                }
            }
            catch
            {
                log.LogError("DeviceRegister:::: Exception occoured");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
            log.LogInformation("DeviceRegister:::: Found Policy({0}) ID : {1} ", policyName, policyId);

            //---------------------------Register FTD------------------------------------------
            //Orchestrator will retry if failed
            log.LogInformation("DeviceRegister:::: Registering FTD with FMC");
            log.LogWarning("Grouping this FTD under Device Group :{0}", devGroupName);
            var devGrpObj = new fmcObjectClass();
            var getId = new getDevIdByNameClass();
            string devGroupId = getId.getDevGroupIdByName(devGroupName, authToken, log);
            if ("ERROR" == devGroupId)
            {
                log.LogError("Unable to get Device Group ID");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }

            log.LogInformation("Device group name : {0}, ID: {1}", devGroupName, devGroupId);
            log.LogWarning("License detailed entered by user : {0}", license);
            license = license.Replace(" ", "");
            license = license.Replace(",", "\",\"");
            license = "\"" + license + "\"";
            log.LogWarning("License after formatting: {0}", license);

            //  string regRequestContent = "{\r\n  \"name\": \"" + ftdDevName + "\",\r\n \"hostName\": \"" + ftdPublicIp + "\",\r\n \"regKey\": \"" + regKey + "\",\r\n \"natID\": \"" + natId + "\",\r\n \"type\": \"Device\",\r\n \"license_caps\": [\r\n  \"BASE\",\r\n  \"MALWARE\",\r\n  \"URLFilter\",\r\n \"THREAT\"\r\n  ],\r\n \"accessPolicy\": {\r\n \"id\": \"" + policyId + "\",\r\n \"type\": \"AccessPolicy\"\r\n  },\r\n  \"deviceGroup\": {\r\n \"id\": \"" + devGroupId + "\", \r\n  \"type\": \"DeviceGroup\" \r\n } \r\n }";

            //sameer change
            string regRequestContent = "{\r\n  \"name\": \"" + ftdDevName + "\",\r\n \"hostName\": \"" + ftdPublicIp + "\",\r\n \"regKey\": \"" + regKey + "\",\r\n \"natID\": \"" + natId + "\",\r\n \"type\": \"Device\",\r\n \"license_caps\": [" + license + "],\r\n \"performanceTier\": \"" + performanceTier + "\",\r\n \"accessPolicy\": {\r\n \"id\": \"" + policyId + "\",\r\n \"type\": \"AccessPolicy\"\r\n  },\r\n  \"deviceGroup\": {\r\n \"id\": \"" + devGroupId + "\", \r\n  \"type\": \"DeviceGroup\" \r\n } \r\n }";

            log.LogInformation("DeviceRegister:::: Registration Content : {0}", regRequestContent);

            var restPost = new fmcRestApiClass();
            string reg_response = restPost.fmcRestApiPost(fmcRegistrationUrl, authToken, log, regRequestContent);
            if ("ERROR" == reg_response)
            {
                log.LogError("DeviceRegister:::: Failed Device Registration");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //  return (ActionResult)new BadRequestObjectResult("ERROR : Failed Device Registration");
            }

            string retVal = "{ \"ftdDevName\" : \"" + ftdDevName + "\" }";
            return (ActionResult)new OkObjectResult(retVal);
        }
    }

    //******************************************************De-Register*****************************************************************
    public static class DeviceDeRegister
    {
        [FunctionName("DeviceDeRegister")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);
            string ftdPublicIp = req.Query["ftdPublicIp"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdPublicIp = ftdPublicIp ?? data?.ftdPublicIp;

            string ftdDevName = req.Query["ftdDevName"];
            string requestBodyName = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic dataName = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;

            string authToken = "";
            string devId = "";

            //FMC URLs for REST API's
            var fmcRegistrationUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devices/devicerecords";

            log.LogWarning("DeviceDeRegister:::: Received Request to De-Register FTD from FMC");
            log.LogInformation("DeviceDeRegister:::: FTD Public IP : {0}", ftdPublicIp);
            log.LogInformation("DeviceDeRegister:::: FMC IP : {0}", fmcIP);

            //------------Get authentication token------------------------------------------
            log.LogInformation("DeviceDeRegister:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("DeviceDeRegister:::: Failed to get Auth token");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }
            log.LogInformation("DeviceDeRegister:::: Successfully got Authentication Token with length:{0}", authToken.Length);

            //---------------------------Get Device ID by name------------------------------------------
            log.LogInformation("DeviceDeRegister:::: Getting FTD Device ID by name");

            var getId = new getDevIdByNameClass();
            devId = getId.getDevIdByName(ftdDevName, authToken, log, "FTD", null);
            if ("ERROR" == devId)
            {
                log.LogError("DeviceDeRegister:::: Failed to get Device ID");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                // return (ActionResult)new BadRequestObjectResult("ERROR: Unable to get Device ID from Device Name");
            }

            //---------------------------De-Register FTD------------------------------------------
            //Orchestrator will retry if this fails
            log.LogInformation("DeviceDeRegister:::: De-Registering FTD");
            var fmcDeRegisterUrl = fmcRegistrationUrl + "/" + devId;
            var deRegClient = new fmcRestApiClass();
            string response = deRegClient.fmcRestApiDelete(fmcDeRegisterUrl, authToken, log);
            if ("ERROR" == response)
            {
                log.LogError("DeviceDeRegister:::: DeRegistration failed");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }

            log.LogInformation("DeviceDeRegister:::: De-Registeration Status : {0}", response);
            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }

    //---------------------------------------Configure FTD device interfaces-----------------------
    public static class ConfigureFtdInterfaces
    {
        [FunctionName("ConfigureFtdInterfaces")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            var fmcInsideZone = System.Environment.GetEnvironmentVariable("INSIDE_ZONE", EnvironmentVariableTarget.Process);
            var fmcInsideNicName = System.Environment.GetEnvironmentVariable("INSIDE_NIC_NAME", EnvironmentVariableTarget.Process);
            var fmcInsideNic = System.Environment.GetEnvironmentVariable("INSIDE_NIC_INTERFACE", EnvironmentVariableTarget.Process);
            var fmcOutsideZone = System.Environment.GetEnvironmentVariable("OUTSIDE_ZONE", EnvironmentVariableTarget.Process);
            var fmcOutsideNicName = System.Environment.GetEnvironmentVariable("OUTSIDE_NIC_NAME", EnvironmentVariableTarget.Process);
            var fmcOutsideNic = System.Environment.GetEnvironmentVariable("OUTSIDE_NIC_INTERFACE", EnvironmentVariableTarget.Process);
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string ftdDevName = req.Query["ftdDevName"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;

            string insideNicId = "";
            string outsideNicId = "";
            string authToken = "";
            string devId = "";
            var fmcRegistrationUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devices/devicerecords";

            log.LogWarning("ConfigureFtdInterfaces:::: Started Device Configuration for {0}", ftdDevName);

            //------------Get authentication token------------------------------------------
            log.LogInformation("ConfigureFtdInterfaces:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("ConfigureFtdInterfaces:::: Failed to get Auth token");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }
            log.LogInformation("ConfigureFtdInterfaces:::: Successfully got Authentication Token with length:{0}", authToken.Length);

            //------------Get resource Ids------------------------------------------
            var getId = new getDevIdByNameClass();
            log.LogInformation("ConfigureFtdInterfaces:::: Getting FTD device ID");
            devId = getId.getDevIdByName(ftdDevName, authToken, log, "FTD", null);
            if ("ERROR" == devId)
            {
                log.LogError("ConfigureFtdInterfaces:::: Failed to get Device ID");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Unable to get Device ID from Device Name");
            }

            log.LogInformation("ConfigureFtdInterfaces:::: Getting Inside NIC ID");
            insideNicId = getId.getDevIdByName(fmcInsideNic, authToken, log, "NIC", devId);
            if ("ERROR" == insideNicId)
            {
                log.LogError("ConfigureFtdInterfaces:::: Failed to get Inside NIC Id");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR : Failed get  Inside NIC Id");
            }
            log.LogInformation("ConfigureFtdInterfaces:::: Inside NIC ID : {0}", insideNicId);


            log.LogInformation("ConfigureFtdInterfaces:::: Getting Outside NIC ID");
            outsideNicId = getId.getDevIdByName(fmcOutsideNic, authToken, log, "NIC", devId);
            if ("ERROR" == outsideNicId)
            {
                log.LogError("ConfigureFtdInterfaces:::: Failed to get Outside NIC Id");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR : Failed get  Outside NIC Id");
            }
            log.LogInformation("ConfigureFtdInterfaces:::: Outside NIC ID : {0}", outsideNicId);

            //------------Get zone Id by name------------------------------------------

            var inZoneId = getId.getDevIdByName(fmcInsideZone, authToken, log, "ZONE", null);
            if ("ERROR" == inZoneId)
            {
                log.LogError("ConfigureFtdInterfaces:::: Failed to get inside zone Id");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR : Failed get  inside zone Id");
            }
            log.LogInformation("ConfigureFtdInterfaces:::: Inside zone ID : {0}", inZoneId);

            var outZoneId = getId.getDevIdByName(fmcOutsideZone, authToken, log, "ZONE", null);
            if ("ERROR" == outZoneId)
            {
                log.LogError("ConfigureFtdInterfaces:::: Failed to get outside zone Id");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                // return (ActionResult)new BadRequestObjectResult("ERROR : Failed get  outside zone Id");
            }
            log.LogInformation("ConfigureFtdInterfaces:::: Outside zone ID : {0}", outZoneId);



            //-------------------Configure inside interface
            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devices/devicerecords/" + devId + "/physicalinterfaces/" + insideNicId;
            string body = "{ \"type\": \"PhysicalInterface\",  \"managementOnly\": \"false\", \"MTU\": 1500, \"ipv4\": { \"dhcp\": { \"enableDefaultRouteDHCP\": \"false\",  \"dhcpRouteMetric\": 1  }  },  \"securityZone\": {  \"id\": \"" + inZoneId + "\",  \"type\": \"SecurityZone\"  }, \"mode\": \"NONE\",  \"ifname\": \"" + fmcInsideNicName + "\",  \"enabled\": \"true\",  \"name\": \"" + fmcInsideNic + "\",  \"id\": \"" + insideNicId + "\" }";

            var restPost = new fmcRestApiClass();
            string response1 = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response1)
            {
                log.LogError("ConfigureFtdInterfaces:::: Failed to configure inside interface");
                //return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR:Failed to configure inside interface");
            }
            log.LogInformation("ConfigureFtdInterfaces:::: Successfully configured Inside Interface");

            //-------------------Configure outside interface
            uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devices/devicerecords/" + devId + "/physicalinterfaces/" + outsideNicId;
            body = "{ \"type\": \"PhysicalInterface\",  \"managementOnly\": \"false\", \"MTU\": 1500, \"ipv4\": { \"dhcp\": { \"enableDefaultRouteDHCP\": \"false\",  \"dhcpRouteMetric\": 1  }  },  \"securityZone\": {  \"id\": \"" + outZoneId + "\",  \"type\": \"SecurityZone\"  }, \"mode\": \"NONE\",  \"ifname\": \"" + fmcOutsideNicName + "\",  \"enabled\": \"true\",  \"name\": \"" + fmcOutsideNic + "\",  \"id\": \"" + outsideNicId + "\" }";

            restPost = new fmcRestApiClass();
            string response2 = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response2)
            {
                log.LogError("ConfigureFtdInterfaces:::: Failed to configure outside interface");
                //  return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                // return (ActionResult)new BadRequestObjectResult("ERROR:Failed to configure outside interface");
            }

            //Orchestrator will retry if failed
            if (("ERROR" == response1) || ("ERROR" == response2))
            {
                log.LogError("ConfigureFtdInterfaces:::: Failed to configure inside or outside interface");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }

            log.LogInformation("ConfigureFtdInterfaces:::: Successfully configured Outside Interface");
            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }

    //---------------------------------------Create static Routes-----------------------
    public static class CreateStaticRoutes
    {
        [FunctionName("CreateStaticRoutes")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            var fmcInsideZone = System.Environment.GetEnvironmentVariable("INSIDE_ZONE", EnvironmentVariableTarget.Process);
            var fmcInsideNicName = System.Environment.GetEnvironmentVariable("INSIDE_NIC_NAME", EnvironmentVariableTarget.Process);
            var fmcInsideNic = System.Environment.GetEnvironmentVariable("INSIDE_NIC_INTERFACE", EnvironmentVariableTarget.Process);
            var fmcOutsideZone = System.Environment.GetEnvironmentVariable("OUTSIDE_ZONE", EnvironmentVariableTarget.Process);
            var fmcOutsideNicName = System.Environment.GetEnvironmentVariable("OUTSIDE_NIC_NAME", EnvironmentVariableTarget.Process);
            var fmcOutsideNic = System.Environment.GetEnvironmentVariable("OUTSIDE_NIC_INTERFACE", EnvironmentVariableTarget.Process);

            var outside_gw = System.Environment.GetEnvironmentVariable("OUTSIDE_GW_OBJ_NAME", EnvironmentVariableTarget.Process);
            var inside_gw = System.Environment.GetEnvironmentVariable("INSIDE_GW_OBJ_NAME", EnvironmentVariableTarget.Process);
            string cidr = System.Environment.GetEnvironmentVariable("NETWORK_CIDR", EnvironmentVariableTarget.Process);
            string out_gw = System.Environment.GetEnvironmentVariable("OUT_NET_GW", EnvironmentVariableTarget.Process);
            string in_gw = System.Environment.GetEnvironmentVariable("IN_NET_GW", EnvironmentVariableTarget.Process);
            string azure_utility_ip = System.Environment.GetEnvironmentVariable("AZURE_UTILITY_IP", EnvironmentVariableTarget.Process);
            string azure_utility_ip_name = System.Environment.GetEnvironmentVariable("AZURE_UTILITY_IP_NAME", EnvironmentVariableTarget.Process);
            string any_ipv4_name = System.Environment.GetEnvironmentVariable("ANY_IPV4_NAME", EnvironmentVariableTarget.Process);
            string network_name = System.Environment.GetEnvironmentVariable("NETWORK_NAME", EnvironmentVariableTarget.Process);

            string ftdDevName = req.Query["ftdDevName"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;
            string ftdPrivateIp = req.Query["ftdPrivateIp"];
            string requestBodyip = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic dataip = JsonConvert.DeserializeObject(requestBody);
            ftdPrivateIp = ftdPrivateIp ?? data?.ftdPrivateIp;

            string authToken = "";

            log.LogWarning("CreateStaticRoutes:::: EJKBEGIN CLASS Creating static routes {0} : {1}", ftdDevName, ftdPrivateIp);

            //-----------------get Auth token------
            log.LogInformation("CreateStaticRoutes:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("CreateStaticRoutes:::: Failed to get Auth token");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }

            //----------------Create Host Object--------
            log.LogInformation("CreateStaticRoutes:::: Creating objects");
            var hostObj = new fmcObjectClass();

            //Orchestrator will retry if failed
            string response = "";
            response = hostObj.fmcHostObjectCreate(authToken, outside_gw, out_gw, log, "Host Object for outside gateway");
            response = hostObj.fmcHostObjectCreate(authToken, inside_gw, in_gw, log, "Host Object for inside gateway");
            response = hostObj.fmcHostObjectCreate(authToken, azure_utility_ip_name, azure_utility_ip, log, "Host Object for azure_utility_ip");

            //Create Network objects
            response = hostObj.fmcNetworkObjectCreate(authToken, any_ipv4_name, "0.0.0.0/0", log, "network object for any ip");
            // Add this statement if you want to use a network object instead of a network group for inside routing:
            // response = hostObj.fmcNetworkObjectCreate(authToken, network_name, cidr, log, "network object for local net cidr");

            //Create Network Group objects
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            // !! This statement does not work as written and is only included as a placeholder !!
            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            // response = hostObj.fmcNetworkGroupObjectCreate(authToken, "aaax2xaaagG", "[aaax2xaaaHost]", log, "test network object group");

            log.LogInformation("CreateStaticRoutes:::: --------Creating Static routes-------------");
            var getId = new getDevIdByNameClass();
            string devId = getId.getDevIdByName(ftdDevName, authToken, log, "FTD", null);
            string inGwObjId = getId.getObjIdByName(inside_gw, authToken, log, "HOST");
            string outGwObjId = getId.getObjIdByName(outside_gw, authToken, log, "HOST");
            string azureObjId = getId.getObjIdByName(azure_utility_ip_name, authToken, log, "HOST");
            // Substitute this statement if you want to use a network object instead of a network group for inside routing:
            // string vnetObjId = getId.getObjIdByName(network_name, authToken, log, "NETWORK");
            string vnetObjId = getId.getObjIdByName(network_name, authToken, log, "NETWORKGROUP");
            string anyipObjName = getId.getObjIdByName(any_ipv4_name, authToken, log, "NETWORK");

            int routeCreationError = 0;

            //Error check
            if (("ERROR" == devId) || ("ERROR" == inGwObjId) || ("ERROR" == outGwObjId) || ("ERROR" == azureObjId) || ("ERROR" == vnetObjId) || ("ERROR" == anyipObjName))
            {
                log.LogError("CreateStaticRoutes:::: Failed to get Device ID");
                log.LogError("CreateStaticRoutes:::: devId={0}, inGwObjId={1}, outGwObjId={2}, azureObjId={3}, vnetObjId={4}, anyipObjName={5}", devId, inGwObjId, outGwObjId, azureObjId, vnetObjId, anyipObjName);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get resource ID");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
            //FMC bug:: Getting Auth token 2nd time (Some time FMC abruptly invalidates auth token in very short time) 
            log.LogInformation("CreateStaticRoutes:::: Getting Auth token 2nd time");
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("CreateStaticRoutes:::: Failed to get Auth token..2nd time");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }

            if ("ERROR" == hostObj.fmcCreateHostRoutes(authToken, log, devId, fmcInsideNicName, network_name, vnetObjId, inside_gw, inGwObjId, "1"))
            {
                log.LogError("CreateStaticRoutes:::: Failed to create route-1");
                routeCreationError = 1;
                // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to Create route-1");
                // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
            // Substetutethese statements if you want to use a network object instead of a network group for inside routing:
            // if ( "ERROR" == hostObj.fmcCreateHostRoutes(authToken, log, devId, fmcInsideNicName, network_name, vnetObjId, inside_gw, inGwObjId, "1"))
            // {
            //     log.LogError("CreateStaticRoutes:::: Failed to create route-1");
            //     routeCreationError = 1;
            //    // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to Create route-1");
            //    // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            // }
            if ("ERROR" == hostObj.fmcCreateHostRoutes(authToken, log, devId, fmcOutsideNicName, any_ipv4_name, anyipObjName, outside_gw, outGwObjId, "2"))
            {
                log.LogError("CreateStaticRoutes:::: Failed to create route-2");
                routeCreationError = 1;
                // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to Create route-2");
            }
            if ("ERROR" == hostObj.fmcCreateHostRoutes(authToken, log, devId, fmcInsideNicName, azure_utility_ip_name, azureObjId, inside_gw, inGwObjId, "3"))
            {
                log.LogError("CreateStaticRoutes:::: Failed to create route-3");
                routeCreationError = 1;
                // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to Create route-5");
            }

            if (1 == routeCreationError)
            {
                //For Orchestrator to re-try
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }

            log.LogInformation("CreateStaticRoutes:::: Successfully created static routes");
            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }

#if false
    //---------------------------------------Create NAT Rules--------------------
    public static class CreateNatRules
    {
        [FunctionName("CreateNatRules")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            var fmcInsideZone = System.Environment.GetEnvironmentVariable("INSIDE_ZONE", EnvironmentVariableTarget.Process);
            var fmcInsideNicName = System.Environment.GetEnvironmentVariable("INSIDE_NIC_NAME", EnvironmentVariableTarget.Process);
            var fmcInsideNic = System.Environment.GetEnvironmentVariable("INSIDE_NIC_INTERFACE", EnvironmentVariableTarget.Process);
            var fmcOutsideZone = System.Environment.GetEnvironmentVariable("OUTSIDE_ZONE", EnvironmentVariableTarget.Process);
            var fmcOutsideNicName = System.Environment.GetEnvironmentVariable("OUTSIDE_NIC_NAME", EnvironmentVariableTarget.Process);
            var fmcOutsideNic = System.Environment.GetEnvironmentVariable("OUTSIDE_NIC_INTERFACE", EnvironmentVariableTarget.Process); 
            string protocol = System.Environment.GetEnvironmentVariable("TRAFFIC_PROTOCOL", EnvironmentVariableTarget.Process);
            string port = System.Environment.GetEnvironmentVariable("TRAFFIC_PORT", EnvironmentVariableTarget.Process);
            string cidr = System.Environment.GetEnvironmentVariable("NETWORK_CIDR", EnvironmentVariableTarget.Process);
            string out_gw = System.Environment.GetEnvironmentVariable("OUT_NET_GW", EnvironmentVariableTarget.Process);
            string in_gw = System.Environment.GetEnvironmentVariable("IN_NET_GW", EnvironmentVariableTarget.Process);
            string app_ip = System.Environment.GetEnvironmentVariable("APPLICATION_IP", EnvironmentVariableTarget.Process);
            string trafficAppPort = System.Environment.GetEnvironmentVariable("TRAFFIC_APP_PROTOCOL", EnvironmentVariableTarget.Process);
            var outside_gw = System.Environment.GetEnvironmentVariable("OUTSIDE_GW_OBJ_NAME", EnvironmentVariableTarget.Process);
            var inside_gw = System.Environment.GetEnvironmentVariable("INSIDE_GW_OBJ_NAME", EnvironmentVariableTarget.Process);
            string azure_utility_ip = System.Environment.GetEnvironmentVariable("AZURE_UTILITY_IP", EnvironmentVariableTarget.Process);
            string azure_utility_ip_name = System.Environment.GetEnvironmentVariable("AZURE_UTILITY_IP_NAME", EnvironmentVariableTarget.Process);
            string app_obj_name = System.Environment.GetEnvironmentVariable("APPLICATION_NAME", EnvironmentVariableTarget.Process);
            string any_ipv4_name = System.Environment.GetEnvironmentVariable("ANY_IPV4_NAME", EnvironmentVariableTarget.Process);
            string network_name = System.Environment.GetEnvironmentVariable("NETWORK_NAME", EnvironmentVariableTarget.Process);

            string ftdDevName = req.Query["ftdDevName"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;

            string authToken = "";
            string natPolicyName = ftdDevName + "_NAT_Policy";
            log.LogWarning("CreateNatRules:::: Creating NAT policy {0} for {1} ", natPolicyName, ftdDevName);

            //-----------------get Auth token------
            log.LogInformation("CreateNatRules:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("CreateNatRules:::: Failed to get Auth token");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }

            log.LogInformation("CreateNatRules:::: Creating NAT policy");
            var fmcObj = new fmcObjectClass();
            if ("ERROR" == fmcObj.fmcCreateNATpolicy(authToken, log, natPolicyName, "Nat Policy for vmss instance"))
            {
                log.LogError("CreateNatRules:::: Failed to cerate NAT policy");   //Orchestrator will retry
               // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to create NAT policy");
            }

            var getId = new getDevIdByNameClass();
            string deviceId = getId.getDevIdByName(ftdDevName, authToken, log, "FTD", null);
            string policyId = getId.getDevIdByName(natPolicyName, authToken, log, "NAT", null);
            if( ("ERROR" == deviceId) || ("ERROR" == policyId))
            {
                log.LogError("CreateNatRules:::: Failed to get resource ID, deviceId={0}, policyId={1}", deviceId, policyId);
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
               // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to Resource ID");
            }

            log.LogInformation("CreateNatRules:::: Associate NAT policy {0}:{1} with device {2}", natPolicyName, policyId, ftdDevName);
            if("ERROR" == fmcObj.fmcAssociateNATpolicyWithDevice(authToken, log, natPolicyName, policyId, ftdDevName, deviceId))
            {
                log.LogError("CreateNatRules:::: Failed to attach NAT policy to FTD");  //Orchestrator will retry
               // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
               // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to attach NAT policy to FTD");
            }
                        
            var inZoneId = getId.getDevIdByName(fmcInsideZone, authToken, log, "ZONE", null);
            var outZoneId = getId.getDevIdByName(fmcOutsideZone, authToken, log, "ZONE", null);
            var srcObj = getId.getObjIdByName(azure_utility_ip_name, authToken, log, "HOST");
            var destObjMgmt = getId.getObjIdByName(ftdDevName + "_mgmtIp", authToken, log, "HOST");
            var connection = getId.getObjIdByName("SSH", authToken, log, "PORT");
            var anyip = getId.getObjIdByName(any_ipv4_name, authToken, log, "NETWORK");
            var appProtocol = getId.getObjIdByName(trafficAppPort, authToken, log, "PORT");
            var destObjApp = getId.getObjIdByName(app_obj_name, authToken, log, "HOST");

            int natRuleCreationError = 0;

            if ( ("ERROR" == inZoneId) || ("ERROR" == outZoneId) || ("ERROR" == srcObj) || ("ERROR" == destObjMgmt) || ("ERROR" == connection) || ("ERROR" == anyip) || ("ERROR" == appProtocol) || ("ERROR" == destObjApp) )
            {
                log.LogError("CreateNatRules:::: Failed to get resource ID");
                log.LogError("CreateNatRules:::: inZoneId={0}, outZoneId={1}, srcObj={2}, destObjMgmt={3}, connection={4}, anyip={5}, appProtocol={6}, destObjApp={7},", inZoneId, outZoneId, srcObj, destObjMgmt, connection, anyip, appProtocol, destObjApp);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to Resource ID");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }

            //FMC bug:: Getting Auth token 2nd time (Some time FMC abruptly invalidates auth token in very short time) 
            log.LogInformation("CreateNatRules:::: Getting Auth token 2nd time");
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("CreateNatRules:::: Failed to get Auth token..2nd time");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }

            log.LogInformation("CreateNatRules:::: Creating NAT rule-1");
            if ("ERROR" == fmcObj.fmcCreateNatRules(authToken, log, policyId, "DYNAMIC", outZoneId, inZoneId, srcObj, connection, destObjMgmt, connection, "Host"))
            {
                log.LogError("CreateNatRules:::: Failed to cerate NAT rule-1");
                natRuleCreationError = 1;
                //return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
               // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to create NAT rule-1");
            }

            log.LogInformation("CreateNatRules:::: Creating NAT rule-2");
            if ("ERROR" == fmcObj.fmcCreateNatRules(authToken, log, policyId, "DYNAMIC", inZoneId, outZoneId, srcObj, connection, destObjMgmt, connection, "Host"))
            {
                log.LogError("CreateNatRules:::: Failed to cerate NAT rule-2");
                natRuleCreationError = 1;
               // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to create NAT rule-2");
            }

            log.LogInformation("CreateNatRules:::: Creating NAT rule-3");
            if ("ERROR" == fmcObj.fmcCreateNatRules(authToken, log, policyId, "DYNAMIC", outZoneId, inZoneId, anyip, appProtocol, destObjApp, appProtocol, "Network"))
            {
                log.LogError("CreateNatRules:::: Failed to cerate NAT rule-3");
                natRuleCreationError = 1;
               // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to create NAT rule-3");
            }
            log.LogInformation("CreateNatRules:::: Creating NAT rule-4 : Auto NAT");
            if ("ERROR" == fmcObj.fmcCreateAutoNatRules(authToken, log, policyId, "DYNAMIC", inZoneId, outZoneId, anyip))
            {
                log.LogError("CreateNatRules:::: Failed to cerate NAT rule-4");
                natRuleCreationError = 1;
               // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
              //  return (ActionResult)new BadRequestObjectResult("ERROR: Failed to create NAT rule-4");
            }

            if(1 == natRuleCreationError )
            {
                //For Orchestrator to retry
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
            log.LogInformation("CreateNatRules:::: Successfully created NAT policy and rules");
            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }

//---------------------------------------Create Extended NAT Rules--------------------
/* Example Json file format from user
     
{    
  "ExtendedNatRules" : [
      { 
          "description": "rule1",
          "type": "MANUAL", 
		  "natType": "STATIC / DYNAMIC",
          "sourceZoneName": "outside",
		  "destZoneName": "inside", 
		  "originalSourceObjectType" : "Network / Host",
          "originalSourceObjectName":  "any-ipv4", 		  
		  "originalDestinationPortObjectName":  "HTTP",		  
		  "translatedDestinationObjectType" : "Network/Host",
          "translatedDestinationObjectName": "server_12.10.4.4", 
		  "translatedDestinationPortObjectName": "HTTP"
      },
      {
          "description": "rule2",
          "type": "AUTO",
		  "natType": "DYNAMIC / STATIC",
          "sourceZoneName": "outside", 
		  "destZoneName": "inside", 
		  "originalSourceObjectType" : "Network / Host",
          "originalSourceObjectName": "any-ip-v4"
      }
  ]
}
*/
    public static class CreateExtendedNatRules
    {
        [FunctionName("CreateExtendedNatRules")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            string extendedNatRules = System.Environment.GetEnvironmentVariable("EXTENDED_NAT_RULES", EnvironmentVariableTarget.Process);

            if("NA" == extendedNatRules)
            {
                log.LogWarning("CreateExtendedNatRules:::: Extended NAT rule creation is disabled");
                return (ActionResult)new OkObjectResult("SUCCESS");
            }


            string ftdDevName = req.Query["ftdDevName"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;           

            var fmcObj = new fmcObjectClass();
            var getId = new getDevIdByNameClass();
            string natPolicyName = ftdDevName + "_NAT_Policy";

            //-----------------get Auth token------
            log.LogInformation("CreateExtendedNatRules:::: Getting Auth Token");
            string authToken = "";
            var getAuth = new fmcAuthClass();
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("CreateExtendedNatRules:::: Failed to get Auth token");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }

            string policyId = getId.getDevIdByName(natPolicyName, authToken, log, "NAT", null);
            if("ERROR" == policyId)
            {
                log.LogError("CreateExtendedNatRules:::: Unable to get NAT Policy ID for {0}", natPolicyName);
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }

            int ruleCount = 1;
            try
            {           
                //convert string to json object
                JObject o = JObject.Parse(extendedNatRules);
                foreach (var item in o["ExtendedNatRules"])
                {
                    log.LogWarning("CreateExtendedNatRules:::: Extended NAT Rule-{0} details", ruleCount);
                    log.LogInformation("CreateExtendedNatRules:::: Description : {0}", item["description"].ToString());
                    log.LogInformation("CreateExtendedNatRules:::: type : {0}", item["type"].ToString());
                    log.LogInformation("CreateExtendedNatRules:::: natType: {0}", item["natType"].ToString());
                    log.LogInformation("CreateExtendedNatRules:::: sourceZoneName: {0}", item["sourceZoneName"].ToString());
                    log.LogInformation("CreateExtendedNatRules:::: destZoneName: {0}", item["destZoneName"].ToString());
                    log.LogInformation("CreateExtendedNatRules:::: originalSourceObjectName: {0}", item["originalSourceObjectName"].ToString());
                    log.LogInformation("CreateExtendedNatRules:::: originalSourceObjectType: {0}", item["originalSourceObjectType"].ToString());

                    if ("MANUAL" == item["type"].ToString())
                    {
                        log.LogInformation("CreateExtendedNatRules:::: originalDestinationPortObjectName: {0}", item["originalDestinationPortObjectName"].ToString());
                        log.LogInformation("CreateExtendedNatRules:::: translatedDestinationObjectType: {0}", item["translatedDestinationObjectType"].ToString());
                        log.LogInformation("CreateExtendedNatRules:::: translatedDestinationObjectName: {0}", item["translatedDestinationObjectName"].ToString());
                        log.LogInformation("CreateExtendedNatRules:::: translatedDestinationPortObjectName: {0}", item["translatedDestinationPortObjectName"].ToString());
                    }

                    string natType = item["natType"].ToString();
                    string srcObjType = item["originalSourceObjectType"].ToString();
                    var srcZoneId = getId.getDevIdByName(item["sourceZoneName"].ToString(), authToken, log, "ZONE", null);
                    var destZoneId = getId.getDevIdByName(item["destZoneName"].ToString(), authToken, log, "ZONE", null);
                    string srcObj = "ERROR";
                    if("Host" == srcObjType)
                    {
                        log.LogInformation("CreateExtendedNatRules:::: Trying to get ID for {0} with HOST type", item["originalSourceObjectName"].ToString());
                        srcObj = getId.getObjIdByName(item["originalSourceObjectName"].ToString(), authToken, log, "HOST");
                    }
                    else if("Network" == srcObjType)
                    {
                        log.LogInformation("CreateExtendedNatRules:::: Trying to get ID for {0} with Network type", item["originalSourceObjectName"].ToString());
                        srcObj = getId.getObjIdByName(item["originalSourceObjectName"].ToString(), authToken, log, "NETWORK");
                    }


                    if ("MANUAL" == item["type"].ToString())
                    {
                        log.LogWarning("CreateExtendedNatRules:::: Creating Extended Manual NAT rule-{0}", ruleCount);

                        var origPort = getId.getObjIdByName(item["originalDestinationPortObjectName"].ToString(), authToken, log, "PORT");
                        var translatedPort = getId.getObjIdByName(item["translatedDestinationPortObjectName"].ToString(), authToken, log, "PORT");
                        var destObjType = item["translatedDestinationObjectType"].ToString();
                        string destObj = "ERROR";
                        if ("Host" == destObjType)
                        {
                            log.LogInformation("CreateExtendedNatRules:::: Getting ID for {0} with Host type", item["translatedDestinationObjectName"].ToString());
                            destObj = getId.getObjIdByName(item["translatedDestinationObjectName"].ToString(), authToken, log, "HOST");
                        }
                        else if ("Network" == destObjType)
                        {
                            log.LogInformation("CreateExtendedNatRules:::: Getting ID for {0} with Network type", item["translatedDestinationObjectName"].ToString());
                            destObj = getId.getObjIdByName(item["translatedDestinationObjectName"].ToString(), authToken, log, "NETWORK");
                        }

                        if( ("ERROR" == srcZoneId) || ("ERROR" == destZoneId) || ("ERROR" == srcObj) || ("ERROR" == origPort) || ("ERROR" == destObj) || ("ERROR" == translatedPort))
                        {
                            log.LogError("CreateExtendedNatRules:::: Unable to get resource id");
                            return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                        }

                        if ("ERROR" == fmcObj.fmcCreateNatRules(authToken, log, policyId, natType, srcZoneId, destZoneId, srcObj, origPort, destObj, translatedPort, srcObjType))
                        {
                            log.LogError("CreateExtendedNatRules:::: Failed to cerate Extended NAT rule-{0}", ruleCount);
                            return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                        }
                        log.LogInformation("CreateExtendedNatRules:::: Created Extended NAT rule-{0}", ruleCount);

                    }
                    else if ("AUTO" == item["type"].ToString())
                    {
                        log.LogWarning("CreateExtendedNatRules:::: Auto NAT rule creation is not supported");
                        continue;
                    }

                    ruleCount++;  

                }
            }
            catch
            {
                log.LogInformation("CreateExtendedNatRules:::: Exception in creating Extended NAT rule {0}", ruleCount);
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
                                                                    
          
            return (ActionResult)new OkObjectResult("SUCCESS");


        }
    }
#endif
    //---------------------------------------Deploy Configuration--------------------
    public static class DeployConfiguration
    {
        [FunctionName("DeployConfiguration")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);
            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/deployment/deploymentrequests";

            string ftdDevName = req.Query["ftdDevName"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;

            //-----------------get Auth token------
            log.LogInformation("DeployConfiguration:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            string authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("DeployConfiguration:::: Failed to get Auth token");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }

            log.LogWarning("DeployConfiguration:::: Deployment Started");

            var getId = new getDevIdByNameClass();
            string deviceId = getId.getDevIdByName(ftdDevName, authToken, log, "FTD", null);
            string body = "{ \"type\": \"DeploymentRequest\", \"version\": \"0000000000\", \"forceDeploy\": \"True\", \"ignoreWarning\": \"True\", \"deviceList\": [ \"" + deviceId + "\"] } \n";

            //----------for some reason generic rest api fails            
            var client = new RestClient(uri);
            var request = new RestRequest(Method.POST);
            client.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;
            request.AddHeader("cache-control", "no-cache");
            request.AddHeader("Connection", "keep-alive");
            request.AddHeader("content-length", "163");
            request.AddHeader("accept-encoding", "gzip, deflate");
            request.AddHeader("Cache-Control", "no-cache");
            request.AddHeader("Accept", "*/*");
            request.AddHeader("Content-Type", "application/json");
            request.AddHeader("X-auth-access-token", authToken);
            request.AddParameter("undefined", body, ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);

            //Nothing much we can do if this fails
            log.LogInformation("DeployConfiguration:::: RESET API Status code : {0}", response.StatusCode);
            log.LogInformation("DeployConfiguration:::: RESET API Status code : {0} {1}", response.ResponseStatus, response.Content);
            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }

    //---------------------------------------Disable Health Probe --------------------
    public static class DisableHealthProbe
    {
        [FunctionName("DisableHealthProbe")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            var fmcInsideNicName = System.Environment.GetEnvironmentVariable("INSIDE_NIC_NAME", EnvironmentVariableTarget.Process);
            var fmcOutsideNicName = System.Environment.GetEnvironmentVariable("OUTSIDE_NIC_NAME", EnvironmentVariableTarget.Process);
            string azure_utility_ip_name = System.Environment.GetEnvironmentVariable("AZURE_UTILITY_IP_NAME", EnvironmentVariableTarget.Process);
            var outside_gw = System.Environment.GetEnvironmentVariable("OUTSIDE_GW_OBJ_NAME", EnvironmentVariableTarget.Process);

            string ftdDevName = req.Query["ftdDevName"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;

            string authToken = "";
            int routeCreationError = 0;

            log.LogWarning("DisableHealthProbe:::: Disabling health Probe ");

            //-----------------get Auth token------
            log.LogInformation("DisableHealthProbe:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("DisableHealthProbe::::Failed to get Auth token");
                return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }

            var hostObj = new fmcObjectClass();
            var getId = new getDevIdByNameClass();
            string devId = getId.getDevIdByName(ftdDevName, authToken, log, "FTD", null);
            string azureObjId = getId.getObjIdByName(azure_utility_ip_name, authToken, log, "HOST");
            string outGwObjId = getId.getObjIdByName(outside_gw, authToken, log, "HOST");

            if (("ERROR" == outGwObjId) || ("ERROR" == azureObjId))
            {
                log.LogError("CreateStaticRoutes:::: Failed to get Device ID");
                log.LogError("CreateStaticRoutes:::: outGwObjId={0}, azureObjId={1} ", outGwObjId, azureObjId);
                //return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get resource ID");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
            if ("ERROR" == hostObj.fmcCreateHostRoutes(authToken, log, devId, fmcOutsideNicName, azure_utility_ip_name, azureObjId, azure_utility_ip_name, azureObjId, "1"))
            {
                log.LogError("CreateStaticRoutes:::: Failed to create route to disable HP of ELB");
                routeCreationError = 1;
                // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to Create route-1");
                // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }
            if ("ERROR" == hostObj.fmcCreateHostRoutes(authToken, log, devId, fmcInsideNicName, azure_utility_ip_name, azureObjId, outside_gw, outGwObjId, "2"))
            {
                log.LogError("CreateStaticRoutes:::: Failed to create route to disable HP of ILB");
                routeCreationError = 1;
                // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to Create route-1");
                // return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }

            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }
#if false
    //---------------------------------------Delete resources--------------------
    public static class DeleteResources
    {
        [FunctionName("DeleteResources")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {

            string ftdDevName = req.Query["ftdDevName"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;

            string authToken = "";
            string natPolicyName = ftdDevName + "_NAT_Policy";
            log.LogWarning("DeleteResources:::: Delete all the resources of {0}", ftdDevName);

            //-----------------get Auth token------
            log.LogInformation("DeleteResources:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("DeleteResources:::: Failed to get Auth token");
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
                // return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }

            //Orchestrator will retry if error is returned
            log.LogInformation("DeleteResources:::: Deleting NAT policy");
            var fmcObj = new fmcObjectClass();
            var getId = new getDevIdByNameClass();

            string policyId = getId.getDevIdByName(natPolicyName, authToken, log, "NAT", null);
            log.LogInformation("DeleteResources:::: policy id : {0}", policyId);

            string mgmtObjId = getId.getObjIdByName(ftdDevName + "_mgmtIp", authToken, log, "HOST");
            log.LogInformation("DeleteResources:::: Mngt ip object id : {0}", mgmtObjId);

            log.LogWarning("DeleteResources:::: Deleting NAT Policy..");
            var response1 = fmcObj.fmcDeleteNatPolicy(authToken, log, policyId);

            log.LogWarning("DeleteResources:::: Delete Management IP Object ({0})", ftdDevName + "_mgmtIp");
            var response2 = fmcObj.fmcDeleteHostObj(authToken, log, mgmtObjId);

            if ( ("ERROR" == response1) || ("ERROR" == response2) )
            {
                log.LogError("DeleteResources:::: Failed to delete NAT rule :{0}  or Management IP Object : {1}", response1, response2);
                return (ActionResult)new StatusCodeResult(StatusCodes.Status500InternalServerError);
            }

            log.LogInformation("DeleteResources:::: Resource deletion is successful");
            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }

#endif
    //---------------------------------------Wait till deployment is finished--------------------
    public static class WaitForDeploymentTask
    {
        [FunctionName("WaitForDeploymentTask")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            string ftdDevName = req.Query["ftdDevName"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;
            string ftdPublicIp = req.Query["ftdPublicIp"];
            string requestBodyIp = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic dataIp = JsonConvert.DeserializeObject(requestBody);
            ftdPublicIp = ftdPublicIp ?? data?.ftdPublicIp;
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);
            var fmcInsideNic = System.Environment.GetEnvironmentVariable("INSIDE_NIC_INTERFACE", EnvironmentVariableTarget.Process);
            string ftdUserName = System.Environment.GetEnvironmentVariable("FTD_USERNAME", EnvironmentVariableTarget.Process);
            string ftdPassword = System.Environment.GetEnvironmentVariable("FTD_PASSWORD", EnvironmentVariableTarget.Process);
            string authToken = "";
            log.LogWarning("WaitForDeploymentTask:::: Waiting till Deployment task is finished for {0}", ftdDevName);

            //-----------------get Auth token------
            log.LogInformation("WaitForDeploymentTask:::: Getting Auth Token");

            var getAuth = new fmcAuthClass();
            authToken = getAuth.getFmcAuthToken(log);
            if ("ERROR" == authToken)
            {
                log.LogError("WaitForDeploymentTask:::: Failed to get Auth token");
                //Just to fool the orchestrator
                return (ActionResult)new OkObjectResult("INPROGRESS");
            }

            log.LogWarning("WaitForDeploymentTask:::: Checking Deployment state");

            var getId = new getDevIdByNameClass();
            string deviceId = getId.getDevIdByName(ftdDevName, authToken, log, "FTD", null);
            if ("ERROR" == deviceId)
            {
                log.LogWarning("WaitForDeploymentTask:::: FTD {0} still not registered in FMC.. waiting", ftdDevName);
                return (ActionResult)new OkObjectResult("INPROGRESS");
            }

            string insideNicId = getId.getDevIdByName(fmcInsideNic, authToken, log, "NIC", deviceId);
            if ("ERROR" == insideNicId)
            {
                log.LogWarning("WaitForDeploymentTask:::: FTD {0} still not registered in FMC.. waiting");
                return (ActionResult)new OkObjectResult("INPROGRESS");
            }

            var sshObj = new ftdSshClientClass();
            string ret = sshObj.ftdSsh(ftdPublicIp, "Completed", log);
            if ("AVAILABLE" != ret)
            {
                return (ActionResult)new OkObjectResult("INPROGRESS");
            }



#if false  //this does not work for FTD6.5 due to removal of KEX algorithm
            //Wait till FTD is registered with FMC
            var sshClient = new SshClient(ftdPublicIp, ftdUserName, ftdPassword);
            try
            {
                sshClient.Connect();
                SshCommand sshResponse = sshClient.RunCommand("show managers");
                log.LogWarning("WaitForDeploymentTask:::: SSH result : {0}", sshResponse.Result.ToString());

                if (! sshResponse.Result.ToString().Contains("Completed"))
                {
                    log.LogInformation("WaitForDeploymentTask:::: FTD is not yet registered with FMC..wait");
                    return (ActionResult)new OkObjectResult("WAITING");
                }
            }
            catch
            {
                log.LogInformation("WaitForDeploymentTask:::: FTD is Not ready");
                return (ActionResult)new OkObjectResult("WAITING");
            }
 
#endif
            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/deployment/deployabledevices";
            var deployClient = new RestClient(uri);
            var deployStatusRequest = new RestRequest(Method.GET);

            //Disable SSL certificate check
            deployClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;
            deployStatusRequest.AddHeader("X-auth-access-token", authToken);
            var response = deployClient.Execute(deployStatusRequest);
            if (response.StatusCode.ToString() != "OK")
            {
                log.LogError("WaitForDeploymentTask:::: Failed get Policy ID (Status Code : {0}", response.StatusCode);
                return (ActionResult)new BadRequestObjectResult("ERROR : Failed deployable device list");
            }

            log.LogInformation("WaitForDeploymentTask:::: Successfully got Response for deployment status ");
            log.LogDebug("WaitForDeploymentTask:::: response : {0}", response.Content);
            try
            {
                //convert string to json object
                JObject o = JObject.Parse(response.Content);
                foreach (var item in o["items"])
                {

                    if (("DeployableDevice" == item["type"].ToString()) && (ftdDevName == item["name"].ToString()))
                    {
                        log.LogInformation("WaitForDeploymentTask:::: Deployment is still in progress for {0}", ftdDevName);
                        return (ActionResult)new OkObjectResult("INPROGRESS");
                    }
                }
            }
            catch
            {
                log.LogInformation("WaitForDeploymentTask:::: Deployment completed for {0}", ftdDevName);
                return (ActionResult)new OkObjectResult("COMPLETED");
            }
            log.LogInformation("WaitForDeploymentTask:::: Deployment completed for {0}", ftdDevName);
            return (ActionResult)new OkObjectResult("COMPLETED");
        }
    }

    //---------------------------------------Wait for FTD to come up--------------------
    public static class WaitForFtdToComeUp
    {
        [FunctionName("WaitForFtdToComeUp")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            string ftdUserName = System.Environment.GetEnvironmentVariable("FTD_USERNAME", EnvironmentVariableTarget.Process);
            string ftdPassword = System.Environment.GetEnvironmentVariable("FTD_PASSWORD", EnvironmentVariableTarget.Process);
            string setUniqueHostName = System.Environment.GetEnvironmentVariable("SET_UNIQUE_HOST_NAME", EnvironmentVariableTarget.Process);
            string ftdPublicIp = req.Query["ftdPublicIp"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdPublicIp = ftdPublicIp ?? data?.ftdPublicIp;
            string ftdDevName = req.Query["ftdDevName"];
            string requestBodyName = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic dataName = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;

            var sshObj = new ftdSshClientClass();
            string ret = sshObj.ftdSsh(ftdPublicIp, "pending", log);
            if ("AVAILABLE" == ret)
            {
                if ("YES" == setUniqueHostName)
                {
                    log.LogInformation("Setting host name to {0}", ftdDevName);
                    sshObj.ftdSshSetHostName(ftdPublicIp, ftdDevName, log);
                }
                return (ActionResult)new OkObjectResult("READY");
            }

            return (ActionResult)new OkObjectResult("WAITING");



            //This works for FTD 6.4, but in FTD 6.5 "diffie-hellman-group-exchange-sha256ï¿½ KEX is removed from sshd_config and c# does not have any client which works without this
            //Keeping this for reference
#if false
             var sshClient = new SshClient(ftdPublicIp, ftdUserName, ftdPassword);
            log.LogInformation("WaitForFtdToComeUp:::: Waiting for FTD {0} to come up", ftdPublicIp);
            try
            {
                sshClient.Connect();
                SshCommand response = sshClient.RunCommand("show managers");
                log.LogWarning("WaitForFtdToComeUp:::: SSH result : {0}", response.Result.ToString());
                if(response.Result.ToString().Contains("pending"))
                {
                    log.LogInformation("WaitForFtdToComeUp:::: FTD is UP and ready to register with FMC");
                    return (ActionResult)new OkObjectResult("READY");
                }
                else
                {
                    log.LogInformation("WaitForFtdToComeUp:::: SSH is UP but not yet ready to register with FMC");
                }
            }
            catch
            {
                log.LogInformation("WaitForFtdToComeUp:::: FTD is Not ready..Still SSH is not enabled");
                return (ActionResult)new OkObjectResult("WAITING");
            }
            log.LogInformation("WaitForFtdToComeUp:::: FTD is Not ready");
            return (ActionResult)new OkObjectResult("WAITING");
            //This was work around tried for 6.5..somewhat it works but risky
            try
            {
                sshClient.Connect();
            }
            catch (Renci.SshNet.Common.SshException x)
            {
                if (x.ToString().Contains("key"))
                {
                    log.LogInformation("WaitForFtdToComeUp:::: SSH is enabled");
                    return (ActionResult)new OkObjectResult("READY");
                }
            }
            catch
            {
                log.LogInformation("WaitForFtdToComeUp:::: FTD is Not ready..Still SSH is not enabled");
                return (ActionResult)new OkObjectResult("WAITING");
            }
            log.LogInformation("WaitForFtdToComeUp:::: FTD is Not ready");
            return (ActionResult)new OkObjectResult("WAITING");
#endif
        }
    }

    //---------------------------------------Basic configuration verification-------------------
    public static class MinimumConfigVerification
    {
        [FunctionName("MinimumConfigVerification")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            string policyName = System.Environment.GetEnvironmentVariable("POLICY_NAME", EnvironmentVariableTarget.Process);
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);
            var fmcInsideZone = System.Environment.GetEnvironmentVariable("INSIDE_ZONE", EnvironmentVariableTarget.Process);
            var fmcOutsideZone = System.Environment.GetEnvironmentVariable("OUTSIDE_ZONE", EnvironmentVariableTarget.Process);
            string devGroupName = System.Environment.GetEnvironmentVariable("DEVICE_GROUP_NAME", EnvironmentVariableTarget.Process);

            string policyId = "";

            //EJK Added log message
            //-----------------Custom Code Version------
            log.LogInformation("MinimumConfigVerification:::: Custom Code v3 July 2021");

            //Check FMC communication
            //-----------------get Auth token------
            log.LogInformation("MinimumConfigVerification:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            string authToken = getAuth.getFmcAuthToken(log);

            if ("ERROR" == authToken)
            {
                log.LogError("MinimumConfigVerification:::: Failed to get Auth token");
                return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }


            //Check if policy is present in FMC (note: Generic REST GET function has some issue)
            //---------------------------Get Policy ID by name------------------------------------------
            log.LogInformation("MinimumConfigVerification:::: Getting Access policy ID");
            var fmcPolicyUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/policy/accesspolicies";
            var policyClient = new RestClient(fmcPolicyUrl);
            var policyRequest = new RestRequest(Method.GET);

            //Disable SSL certificate check
            policyClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;
            policyRequest.AddHeader("X-auth-access-token", authToken);
            var response = policyClient.Execute(policyRequest);
            if (response.StatusCode.ToString() != "OK")
            {
                log.LogError("MinimumConfigVerification:::: Failed get Policy ID (Status Code : {0}", response.StatusCode);
                return (ActionResult)new BadRequestObjectResult("ERROR : Failed get Policy ID");
            }

            log.LogInformation("MinimumConfigVerification:::: Successfully got Response for policy id request ");
            log.LogDebug("MinimumConfigVerification:::: response : {0}", response.Content);

            try
            {
                //convert string to json object
                JObject o = JObject.Parse(response.Content);
                foreach (var item in o["items"])
                {

                    if (policyName == item["name"].ToString())
                    {
                        policyId = item["id"].ToString();
                        break;
                    }

                }
                if (0 == policyId.Length)
                {
                    log.LogError("MinimumConfigVerification:::: Unable to get Policy ID from Policy Name({0})", policyName);
                    log.LogError("MinimumConfigVerification:::: Contents received from FMC : {0}", response.Content);
                    return (ActionResult)new BadRequestObjectResult("ERROR: Unable to get Policy ID from Policy Name");
                }
            }
            catch
            {
                log.LogError("MinimumConfigVerification:::: Exception occoured");
                return (ActionResult)new BadRequestObjectResult("ERROR: Unable to get Policy ID from Policy Name");
            }

            log.LogInformation("MinimumConfigVerification:::: Found Policy({0}) ID : {1} ", policyName, policyId);

            //Check if objects are present in FMC
            var getId = new getDevIdByNameClass();
            var inZoneId = getId.getDevIdByName(fmcInsideZone, authToken, log, "ZONE", null);
            if ("ERROR" == inZoneId)
            {
                log.LogError("MinimumConfigVerification:::: Failed to get inside zone Id");
                return (ActionResult)new BadRequestObjectResult("ERROR : Failed get  inside zone Id");
            }

            log.LogInformation("MinimumConfigVerification:::: inside zone ID : {0}", inZoneId);

            var outZoneId = getId.getDevIdByName(fmcOutsideZone, authToken, log, "ZONE", null);
            if ("ERROR" == outZoneId)
            {
                log.LogError("MinimumConfigVerification:::: Failed to get outside zone Id");
                return (ActionResult)new BadRequestObjectResult("ERROR : Failed get  outside zone Id");
            }

            log.LogInformation("MinimumConfigVerification:::: outside zone ID : {0}", outZoneId);

            string devGroupId = getId.getDevGroupIdByName(devGroupName, authToken, log);
            if ("ERROR" == devGroupId)
            {
                log.LogError("MinimumConfigVerification:::: Unable to get Device Group ID");
                return (ActionResult)new BadRequestObjectResult("ERROR : Failed get Device Group Id");

            }
            log.LogInformation("MinimumConfigVerification:::: Device Group ID : {0}", devGroupId);
#if false //This is creating timing issues
            //if Garbage collector in ON then identify orphen FTDs in Azure and delete them
            //Lets delete only 1 FTD per cycle.. so that if there is any issue in logic / FMC REST API ..damage can be delayed
            //Return Error so that other operation will not continue and get some time for next cycle
            var collectGarbage = System.Environment.GetEnvironmentVariable("GARBAGE_COLLECTOR", EnvironmentVariableTarget.Process);
            if ("ON" == collectGarbage)
            {
                log.LogWarning("MinimumConfigVerification:::: Garbage collector is ON, detecting orphan FTDs in Azure");
                var resoureGroupName = System.Environment.GetEnvironmentVariable("RESOURCE_GROUP_NAME", EnvironmentVariableTarget.Process);
                var vmScalesetName = System.Environment.GetEnvironmentVariable("VMSS_NAME", EnvironmentVariableTarget.Process);
                var factory = new AzureCredentialsFactory();
                var devId = new getDevIdByNameClass();

                var msiCred = factory.FromMSI(new MSILoginInformation(MSIResourceType.AppService), AzureEnvironment.AzureGlobalCloud);
                var azure = Azure.Configure().WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic).Authenticate(msiCred).WithDefaultSubscription();
                var vmss = azure.VirtualMachineScaleSets.GetByResourceGroup(resoureGroupName, vmScalesetName);

                log.LogWarning("MinimumConfigVerification:::: FTD count : {0}", vmss.Capacity.ToString());

                if (0 != vmss.Capacity)
                {
                    foreach (var vm in vmss.VirtualMachines.List())
                    {
                        log.LogInformation("MinimumConfigVerification:::: Check if {0} is present in FMC", vm.Name);

                        if ("ERROR" == devId.getDevIdByName(vm.Name, authToken, log, "FTD", null))
                        {
                            log.LogWarning("MinimumConfigVerification:::: FTD {0} is only present in Azure and not present in FMC...Deleting it", vm.Name);
                            var computeManagementClient = new ComputeManagementClient(msiCred) { SubscriptionId = azure.SubscriptionId };
                            int operationDelay = 30000; //30sec
                            var del = computeManagementClient.VirtualMachineScaleSetVMs.DeleteWithHttpMessagesAsync(resoureGroupName, vmScalesetName, vm.InstanceId);
                            del.Wait(operationDelay);
                            log.LogWarning("MinimumConfigVerification:::: Deleted FTD {0}", vm.Name);
                            return (ActionResult)new BadRequestObjectResult("DELETED Garbage FTD");
                        }
                    }
                }
            }
            else
            {
                log.LogWarning("MinimumConfigVerification:::: Considering Garbage collector is OFF..");
            }
#endif
            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }


    //---------------------------------------Delete un-registered FTD-------------------
    public static class DeleteUnRegisteredFTD
    {
        [FunctionName("DeleteUnRegisteredFTD")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            var delBadFTD = System.Environment.GetEnvironmentVariable("DELETE_FAULTY_FTD", EnvironmentVariableTarget.Process);
            var subscriptionId = System.Environment.GetEnvironmentVariable("SUBSCRIPTION_ID", EnvironmentVariableTarget.Process);
            string ftdDevName = req.Query["ftdDevName"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            ftdDevName = ftdDevName ?? data?.ftdDevName;

            if ("YES" != delBadFTD)
            {
                log.LogWarning("DeleteUnRegisteredFTD:::: Feature to delete unregistered FTD is not enabled");
                return (ActionResult)new OkObjectResult("SUCCESS");
            }

            //-----------------get Auth token------
            log.LogInformation("DeleteUnRegisteredFTD:::: Getting Auth Token");
            var getAuth = new fmcAuthClass();
            string authToken = getAuth.getFmcAuthToken(log);

            if ("ERROR" == authToken)
            {
                log.LogError("DeleteUnRegisteredFTD:::: Failed to get Auth token");
                return (ActionResult)new BadRequestObjectResult("ERROR: Failed to get Auth Token");
            }

            log.LogWarning("DeleteUnRegisteredFTD:::: Checking if {0} is registered to FMC", ftdDevName);
            var devId = new getDevIdByNameClass();
            var ftdId = devId.getDevIdByName(ftdDevName, authToken, log, "FTD", null);
            if ("ERROR" == ftdId)
            {
                log.LogError("DeleteUnRegisteredFTD:::: FTD {0} is not registered to FMC.. Deleting it from Azure", ftdDevName);
                var resoureGroupName = System.Environment.GetEnvironmentVariable("RESOURCE_GROUP_NAME", EnvironmentVariableTarget.Process);
                var vmScalesetName = System.Environment.GetEnvironmentVariable("VMSS_NAME", EnvironmentVariableTarget.Process);
                var factory = new AzureCredentialsFactory();
                var msiCred = factory.FromMSI(new MSILoginInformation(MSIResourceType.AppService), AzureEnvironment.AzureGlobalCloud);
                var azure = Azure.Configure().WithLogLevel(HttpLoggingDelegatingHandler.Level.Basic).Authenticate(msiCred).WithSubscription(subscriptionId);
                var vmss = azure.VirtualMachineScaleSets.GetByResourceGroup(resoureGroupName, vmScalesetName);
                foreach (var vm in vmss.VirtualMachines.List())
                {
                    if (ftdDevName == vm.Name)
                    {
                        log.LogWarning("DeleteUnRegisteredFTD:::: Found {0} in Azure, Azure instance Id : {1}", vm.Name, vm.InstanceId);
                        var computeManagementClient = new ComputeManagementClient(msiCred) { SubscriptionId = azure.SubscriptionId };
                        int operationDelay = 30000; //30sec
                        var del = computeManagementClient.VirtualMachineScaleSetVMs.DeleteWithHttpMessagesAsync(resoureGroupName, vmScalesetName, vm.InstanceId);
                        del.Wait(operationDelay);
                        log.LogWarning("DeleteUnRegisteredFTD:::: Deleted FTD {0}", vm.Name);
                        return (ActionResult)new BadRequestObjectResult("DELETED Unregistered FTD");
                    }
                }
                log.LogError("DeleteUnRegisteredFTD:::: Unable to find {0} in Azure VMSS", ftdDevName);
                return (ActionResult)new BadRequestObjectResult("Unable to find this FTD in Azure");
            }
            else
            {
                log.LogWarning("DeleteUnRegisteredFTD:::: FTD {0} is registered to FMC", ftdDevName);
            }

            return (ActionResult)new OkObjectResult("SUCCESS");
        }
    }
}
