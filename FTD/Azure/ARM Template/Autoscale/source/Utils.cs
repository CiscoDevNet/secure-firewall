//  Copyright (c) 2020 Cisco Systems Inc or its affiliates.
//  EK Modified NO to NGO
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
using System.Diagnostics;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using RestSharp;
using RestSharp.Authenticators;
using RestClient = RestSharp.RestClient;

//FMC Get Authentication Token
namespace fmcAuth
{
    public class fmcAuthClass
    {
        //****************************Get FMC Authentication token using credentials**************************
        public string getFmcAuthToken(ILogger log)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUserName = System.Environment.GetEnvironmentVariable("FMC_USERNAME", EnvironmentVariableTarget.Process);
            string fmcPassword = System.Environment.GetEnvironmentVariable("FMC_PASSWORD", EnvironmentVariableTarget.Process);
                       
            //FMC URLs for REST API's
            var fmcAuthUrl = "https://" + fmcIP + "/api/fmc_platform/v1/auth/generatetoken";
            int authTokenPosition = 6;
            string authToken = "";
            string authResponse = "";

            log.LogInformation("util:::: FMC IP : {0}", fmcIP);


            //------------Get authentication token------------------------------------------
            log.LogInformation("util:::: Getting Auth Token");

            var authClient = new RestClient(fmcAuthUrl);
            authClient.Authenticator = new HttpBasicAuthenticator(fmcUserName, fmcPassword);
            //Disable SSL Certificate check
            authClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;
            //Get Token
            var authRequest = new RestRequest(Method.POST);

            try
            {
                authResponse = authClient.Execute(authRequest).Headers[authTokenPosition].ToString();
                if (!authResponse.Contains("X-auth-access-token"))
                {
                    log.LogError("util:::: Failed to get Auth token");
                    return "ERROR";
                }
            }
            catch
            {
                log.LogError("util:::: Exception : Failed to get Auth token");
                return "ERROR";
            }

            //Finally parse header and get Auth Token
            authToken = authResponse.Split("=")[1];
            log.LogInformation("util:::: Auth Token generation : Success");
            return authToken;
        }
    }
}

//*********************************************Get Device IDs from FMC****************************************************************
namespace getDevIdByName
{
    public class getDevIdByNameClass
    {
        public string getDevIdByName(string devName, string authToken, ILogger log, string cmd, string optional_dev_Id)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string devId = "";
            var regUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devices/devicerecords";
            if ("FTD" == cmd)
            {
                log.LogInformation("util:::: Getting FTD ({0}) Device ID", devName);
            }
            else if ("NIC" == cmd)
            {
                log.LogInformation("util:::: Getting NIC ({0}) Device ID", devName);
                regUrl = regUrl + "/" + optional_dev_Id + "/physicalinterfaces";
                log.LogWarning("util:::: URL : {0}", regUrl);

            }
            else if ("ZONE" == cmd)
            {
                log.LogInformation("util:::: Getting Zone ({0}) Device ID", devName);
                regUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/object/securityzones";
            }
            else if ("NAT" == cmd)
            {
                log.LogInformation("util:::: Getting NAT policy ({0}) ID", devName);
                regUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/policy/ftdnatpolicies";
            }
            else
            {
                log.LogError("util:::: Unknown command");
                return "ERROR";
            }

            regUrl = regUrl + "?offset=0&limit=1000";

            var devClient = new RestClient(regUrl);
            var devRequest = new RestRequest(Method.GET);

            //Disable SSL certificate check
            devClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;

            devRequest.AddHeader("X-auth-access-token", authToken);

            var response = devClient.Execute(devRequest);

            if (response.StatusCode.ToString() != "OK")
            {
                log.LogError("util:::: Failed get Device ID (Status Code : {0}", response.StatusCode);
                return "ERROR";
            }

            log.LogInformation("util:::: Successfully got Response for Device id request ");
            log.LogDebug("util:::: response : {0}", response.Content);

            try
            {
                //convert string to json object
                JObject o = JObject.Parse(response.Content);

                foreach (var item in o["items"])
                {
                    if (devName == item["name"].ToString())
                    {
                        devId = item["id"].ToString();
                        break;
                    }
                }

                if (0 == devId.Length)
                {
                    log.LogError("util:::: Unable to get Device ID for Device Name({0})", devName);
                    log.LogError("util:::: Contents received from FMC : {0}", response.Content);
                    return "ERROR";
                }
            }
            catch
            {
                log.LogError("util:::: Exception Occoured");
                return "ERROR";
            }
            log.LogInformation("util:::: Found  Device({0}) ID : {1} ", devName, devId);
            return devId;
        }

        //Get Device Id of all the FTDs
        public string getAllDevId(string authToken, ILogger log)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string devId = "";
            var regUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devices/devicerecords";
            regUrl = regUrl + "?offset=0&limit=1000";

            var devClient = new RestClient(regUrl);
            var devRequest = new RestRequest(Method.GET);

            //Disable SSL certificate check
            devClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;

            devRequest.AddHeader("X-auth-access-token", authToken);

            var response = devClient.Execute(devRequest);

            if (response.StatusCode.ToString() != "OK")
            {
                log.LogError("util:::: Failed get Device ID (Status Code : {0}", response.StatusCode);
                return "ERROR";
            }

            log.LogInformation("util:::: Successfully got Response for Device id request ");
            log.LogDebug("util:::: response : {0}", response.Content);

            //convert string to json object
            return response.Content;

        }


        //*********************Get Object ID by name from FMC*****************************************************************
        public string getObjIdByName(string objName, string authToken, ILogger log, string cmd)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string objId = "";
            string type = "";
            var regUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/object/";
            if ("HOST" == cmd)
            {
                log.LogInformation("util:::: Getting Host obj ({0})  ID", objName);
                regUrl = regUrl + "hosts";
                type = "Host";
            }
            else if ("PORT" == cmd)
            {
                log.LogInformation("util:::: Getting Port obj ({0})  ID", objName);
                regUrl = regUrl + "protocolportobjects";
                type = "ProtocolPortObject";
            }
            else if ("NETWORK" == cmd)
            {
                log.LogInformation("util:::: Getting Network obj ({0})  ID", objName);
                regUrl = regUrl + "networkaddresses";
                type = "Network";
            }
            else if ("NETWORKGROUP" == cmd)
            {
                log.LogInformation("util:::: Getting Network Group obj ({0})  ID", objName);
                regUrl = regUrl + "networkgroups";
                type = "NetworkGroup";
            }
            else
            {
                log.LogError("util:::: Unknown command");
                return "ERROR";
            }

            regUrl = regUrl + "?offset=0&limit=1000";

            var devClient = new RestClient(regUrl);
            var devRequest = new RestRequest(Method.GET);

            //Disable SSL certificate check
            devClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;

            devRequest.AddHeader("X-auth-access-token", authToken);

            var response = devClient.Execute(devRequest);

            if (response.StatusCode.ToString() != "OK")
            {
                log.LogError("util:::: Failed get Device ID (Status Code : {0}", response.StatusCode);
                return "ERROR";
            }

            log.LogInformation("util:::: Successfully got Response for Device id request ");
            log.LogDebug("util:::: response : {0}", response.Content);

            //convert string to json object
            try
            {
                JObject o = JObject.Parse(response.Content);

                foreach (var item in o["items"])
                {
                    if ((objName == item["name"].ToString()) && (type == item["type"].ToString()))
                    {
                        objId = item["id"].ToString();
                        break;
                    }
                }

                if (0 == objId.Length)
                {
                    log.LogError("util:::: Unable to get Device ID for Device Name({0})", objName);
                    log.LogError("util:::: Contents received from FMC : {0}", response.Content);
                    return "ERROR";
                }
            }
            catch
            {
                log.LogError("util:::: Exception occoured");
                return "ERROR";
            }

            log.LogInformation("util:::: Found FTD Device({0}) ID : {1} ", objName, objId);
            return objId;
        }

        //*********************Get Device Group ID by name from FMC*****************************************************************
        public string getDevGroupIdByName(string devGroupName, string authToken, ILogger log)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string objId = "";
            string type = "";
            var regUrl = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devicegroups/devicegrouprecords";
            regUrl = regUrl + "?offset=0&limit=1000";

            var devClient = new RestClient(regUrl);
            var devRequest = new RestRequest(Method.GET);

            //Disable SSL certificate check
            devClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;

            devRequest.AddHeader("X-auth-access-token", authToken);

            var response = devClient.Execute(devRequest);

            if (response.StatusCode.ToString() != "OK")
            {
                log.LogError("util:::: Failed get Device Group ID (Status Code : {0}", response.StatusCode);
                return "ERROR";
            }

            log.LogInformation("util:::: Successfully got Response for Device Group id request ");
            log.LogDebug("util:::: response : {0}", response.Content);

            //convert string to json object
            try
            {
                JObject o = JObject.Parse(response.Content);

                foreach (var item in o["items"])
                {
                    if ((devGroupName == item["name"].ToString()))
                    {
                        objId = item["id"].ToString();
                        break;
                    }
                }

                if (0 == objId.Length)
                {
                    log.LogError("util:::: Unable to get Device Group ID for Device Group Name({0})", devGroupName);
                    log.LogError("util:::: Contents received from FMC : {0}", response.Content);
                    return "ERROR";
                }
            }
            catch
            {
                log.LogError("util:::: Exception occoured");
                return "ERROR";
            }

            log.LogInformation("util:::: Found Device Group ({0}) ID : {1} ", devGroupName, objId);
            return objId;
        }
    }
}

//**************************************REST API Implementation ********************************
namespace fmcRestApi
{
    public class fmcRestApiClass
    {
        //*********************************POST API ****************************************
        public string fmcRestApiPost(string uri, string authToken, ILogger log, string body)
        {
            var restClient = new RestClient(uri);
            var request = new RestRequest(Method.PUT);
            restClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;
            request.AddHeader("X-auth-access-token", authToken);
            request.AddHeader("Content-Type", "application/json");
            request.AddParameter("undefined", body, ParameterType.RequestBody);
            var response = restClient.Execute(request);
            //log.LogInformation("util:::: token {0} ", authToken);
            log.LogInformation("util:::: Post RESET API Status code : {0}", response.StatusCode);
            // log.LogInformation("util:::: RESET API Status code : {0} {1}", response.ResponseStatus,  response.Content);

            if (("OK" != response.StatusCode.ToString()) && ("Created" != response.StatusCode.ToString()) && ("Accepted" != response.StatusCode.ToString()))
            {
                log.LogError("util:::: REST API POST Failed : {0}, {1}, {2}, {3}", response.StatusCode, response.StatusDescription, response.StatusDescription, response.Content);
                return "ERROR";
            }

            return response.StatusCode.ToString();
        }

        //*********************************DELETE API ****************************************
        public string fmcRestApiDelete(string uri, string authToken, ILogger log)
        {
            var restClient = new RestClient(uri);
            var request = new RestRequest(Method.DELETE);
            restClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;
            request.AddHeader("X-auth-access-token", authToken);

            var response = restClient.Execute(request);
            log.LogInformation("util:::: Delete RESET API Status code : {0}", response.StatusCode);

            if ("OK" != response.StatusCode.ToString())
            {
                log.LogError("util:::: REST API Delete Failed : {0}, {1}, {2}, {3}", response.StatusCode, response.StatusDescription, response.StatusDescription, response.Content);
                return "ERROR";
            }

            return response.StatusCode.ToString();
        }
    }
}

//*********************Create Objects in FMC *******************************
namespace fmcObject
{
    using fmcRestApi;
    public class fmcObjectClass
    {

        //****************************Create HOST Objects ********************************************************************
        public string fmcHostObjectCreate(string authToken, string objName, string ip, ILogger log, string description)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/object/hosts";
            string body = "{ \"name\": \"" + objName + "\", \"type\": \"Host\", \"value\": \"" + ip + "\", \"description\": \"" + description + "\" }";

            log.LogInformation("util:::: Creating host object : {0}", objName);
            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to create HOST Object : {0} .. probably already existing", objName);
                return "ERROR";
            }
            return "SUCCESS";
        }

        //****************************Create Network Objects ********************************************************************
        public string fmcNetworkObjectCreate(string authToken, string objName, string ip, ILogger log, string description)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/object/networks";
            string body = "{ \"name\": \"" + objName + "\", \"value\": \"" + ip + "\", \"overridable\": \"False\", \"description\": \"" + description + "\", \"type\": \"Network\"   }";

            log.LogInformation("util:::: Creating Network object : {0}", objName);
            log.LogDebug("util:::: uri : {0}, body : {1}", uri, body);
            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to create Network Object : {0}..probably already existing", objName);
                return "ERROR";
            }
            return "SUCCESS";
        }

        //****************************Create Network Group Objects ********************************************************************
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // !! This routine does not work as written and is only included as a placeholder !!
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        public string fmcNetworkGroupObjectCreate(string authToken, string objName, string netobjs, ILogger log, string description)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/object/networkgroups";
            string body = "{ \"name\": \"" + objName + "\", \"value\": \"" + netobjs + "\", \"overridable\": \"False\", \"description\": \"" + description + "\" }";

            log.LogInformation("util:::: Creating Network Group object : {0}", objName);
            log.LogDebug("util:::: uri : {0}, body : {1}", uri, body);
            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to create Network Group Object : {0}..probably already existing", objName);
                return "ERROR";
            }
            return "SUCCESS";
        }

        //****************************Create PORT Objects ********************************************************************
        public string fmcPortObjectCreate(string authToken, string objName, string port, string protocol, ILogger log, string description)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/object/protocolportobjects";
            string body = "{ \"name\": \"" + objName + "\", \"type\": \"ProtocolPortObject\",  \"protocol\": \"" + protocol + "\", \"port\": \"" + port + "\", \"description\": \"" + description + "\"  }";

            log.LogInformation("util:::: Creating Port object : {0}", objName);
            log.LogDebug("util:::: uri : {0}, body : {1}", uri, body);
            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to create Port Object : {0}..probably already existing", objName);
                return "ERROR";
            }
            return "SUCCESS";
        }

        //****************************Create HOST Static Routes  ********************************************************************
        public string fmcCreateHostRoutes(string authToken, ILogger log, string ngfwid, string interfaceName, string hostObjectNameTarget, string hostObjectIdTarget, string hostObjectNameGw, string hostObjectIdGw, string metric)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devices/devicerecords/" + ngfwid + "/routing/ipv4staticroutes";
            string body = "{ \"interfaceName\":\"" + interfaceName + "\", \"selectedNetworks\": [  {  \"type\": \"Host\", \"id\": \"" + hostObjectIdTarget + "\", \"name\": \"" + hostObjectNameTarget + "\" } ], \"gateway\": { \"object\": { \"type\": \"Host\", \"id\": \"" + hostObjectIdGw + "\", \"name\": \"" + hostObjectNameGw + "\"  } }, \"metricValue\": \"" + metric + "\", \"type\": \"IPv4StaticRoute\",  \"isTunneled\": \"False\" } ";

            log.LogInformation("util:::: Creating host route for {0}:{1}", hostObjectNameTarget, hostObjectNameGw);
            log.LogDebug("util:::: uri : {0},  body : {1}", uri, body);
            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);
            log.LogInformation("util:::: Response : {0}", response);
            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to create host route : {0}:{1}", hostObjectNameTarget, hostObjectNameGw);
                return "ERROR";
            }
            return "SUCCESS";
        }

        //****************************Create NAT Policy ********************************************************************
        public string fmcCreateNATpolicy(string authToken, ILogger log, string policyName, string description)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/policy/ftdnatpolicies";
            string body = "{ \"type\": \"FTDNatPolicy\", \"name\": \"" + policyName + "\", \"description\": \"" + description + "\" }";

            log.LogInformation("util:::: Creating NAT policy {0}", policyName);
            log.LogDebug("util:::: uri : {0},  body : {1}", uri, body);
            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to create NAT policy {0}", policyName);
                return "ERROR";
            }
            return "SUCCESS";
        }

        //****************************Create Associate NAT policy with Device ********************************************************************
        public string fmcAssociateNATpolicyWithDevice(string authToken, ILogger log, string policyName, string policyId, string deviceName, string deviceId)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/assignment/policyassignments";
            string body = "{ \"type\": \"PolicyAssignment\", \"policy\": { \"type\": \"FTDNatPolicy\",  \"id\": \"" + policyId + "\" }, \"targets\": [ {  \"id\": \"" + deviceId + "\", \"type\": \"Device\"  }  ]   }";
            log.LogInformation("util:::: Associating NAT policy {0} with Device {1} ", policyName, deviceName);
            // log.LogInformation("util:::: uri : {0},  body : {1}", uri, body);
            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);

            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to Associate NAT policy {0}", policyName);
                return "ERROR";
            }
            return "SUCCESS";
        }

        //****************************Create NAT Rule  ********************************************************************
        public string fmcCreateNatRules(string authToken, ILogger log, string natPolicyId, string natType, string sourceZoneId, string destZoneId, string originalSourceIpObjectId, string originalDestPortObjectId, string translatedDestIpObjectId, string translatedDestinationPortObjectId, string types)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/policy/ftdnatpolicies/" + natPolicyId + "/manualnatrules";
            string body = "{ \"originalDestinationPort\": { \"type\": \"ProtocolPortObject\", \"id\": \"" + originalDestPortObjectId + "\" }, \"originalSource\": { \"type\": \"" + types + "\", \"id\": \"" + originalSourceIpObjectId + "\" }, \"translatedDestination\": {     \"type\": \"Host\", \"id\": \"" + translatedDestIpObjectId + "\" }, \"translatedDestinationPort\": { \"type\": \"ProtocolPortObject\", \"id\": \"" + translatedDestinationPortObjectId + "\" },     \"unidirectional\": \"True\", \"interfaceInOriginalDestination\": \"True\", \"interfaceInTranslatedSource\": \"True\", \"type\": \"FTDManualNatRule\", \"enabled\": \"True\", \"natType\": \"" + natType + "\",     \"interfaceIpv6\": \"False\",  \"fallThrough\": \"False\", \"dns\": \"False\", \"routeLookup\": \"False\", \"noProxyArp\": \"False\", \"netToNet\": \"False\",     \"sourceInterface\": { \"id\": \"" + sourceZoneId + "\",  \"type\": \"SecurityZone\" },  \"destinationInterface\": { \"id\": \"" + destZoneId + "\", \"type\": \"SecurityZone\" } ,  \"description\": \"\"   }";


            log.LogInformation("util:::: Creating  NAT rule");
            log.LogDebug("util:::: uri : {0},  body : {1}", uri, body);
            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to create host NAT rule ");
                return "ERROR";
            }
            return "SUCCESS";
        }

        //****************************Create Auto NAT Rule ********************************************************************
        public string fmcCreateAutoNatRules(string authToken, ILogger log, string natPolicyId, string natType, string sourceZoneId, string destZoneId, string originalNetworkObjectId)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/policy/ftdnatpolicies/" + natPolicyId + "/autonatrules";
            string body = "{ \"type\": \"FTDAutoNatRule\",  \"originalNetwork\": {   \"type\": \"Network\",   \"id\": \"" + originalNetworkObjectId + "\"  },  \"originalPort\": \"0\", \"translatedPort\": \"0\",   \"interfaceInTranslatedNetwork\": \"True\", \"dns\": \"False\",   \"routeLookup\": \"False\",  \"noProxyArp\": \"False\",    \"netToNet\": \"False\",   \"destinationInterface\": { \"id\": \"" + destZoneId + "\",    \"type\": \"SecurityZone\"   },  \"interfaceIpv6\": \"False\",  \"fallThrough\": \"False\",   \"natType\": \"DYNAMIC\",   \"sourceInterface\": { \"id\": \"" + sourceZoneId + "\",   \"type\": \"SecurityZone\"   },    \"description\": \"\"  } ";

            log.LogInformation("util:::: Creating Auto NAT rule");
            log.LogDebug("util:::: uri : {0},  body : {1}", uri, body);
            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to create Auto NAT rule ");
                return "ERROR";
            }
            return "SUCCESS";
        }

        //**************************** Delete Health Probe NAT Rule ********************************************************************
        public string fmcDeleteHPNatRules(string authToken, ILogger log, string natPolicyId)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/policy/ftdnatpolicies/" + natPolicyId + "/manualnatrules";

            log.LogInformation("util:::: Deleting HP NAT rule..Started");

            var policyClient = new RestClient(uri);
            var policyRequest = new RestRequest(Method.GET);

            //Disable SSL certificate check
            policyClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;

            policyRequest.AddHeader("X-auth-access-token", authToken);

            var response = policyClient.Execute(policyRequest);

            if (response.StatusCode.ToString() != "OK")
            {
                log.LogError("util:::: Failed get NAT rules details from NAT policy");
                return "ERROR";
            }


            try
            {
                JObject o = JObject.Parse(response.Content);
                string hpNatId = o["items"][0]["id"].ToString();
                if (0 == hpNatId.Length)
                {
                    log.LogError("util:::: Failed to get NAT rule id");
                    return "ERROR";
                }



                log.LogInformation("util:::: Gathered HB NAT rule id : {0}", hpNatId.ToString());
                uri = uri + "/" + hpNatId;

                var restPost = new fmcRestApiClass();
                if ("ERROR" == restPost.fmcRestApiDelete(uri, authToken, log))
                {
                    log.LogError("util:::: Failed to remove NAT rule ");
                    return "ERROR";
                }
            }
            catch
            {
                log.LogError("util:::: Exception occoured");
                return "ERROR";
            }

            log.LogInformation("util:::: Deleted NAT rule for Health Probe");
            return "SUCCESS";
        }

        //****************************Delete NAT policy ********************************************************************
        public string fmcDeleteNatPolicy(string authToken, ILogger log, string natPolicyId)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/policy/ftdnatpolicies/" + natPolicyId;

            log.LogInformation("util:::: Deleting NAT Policy Started..");

            var restPost = new fmcRestApiClass();
            var response = restPost.fmcRestApiDelete(uri, authToken, log);
            if ("ERROR" == response.ToString())
            {
                log.LogError("util:::: Failed to remove NAT Policy ");
                return "ERROR";
            }
            log.LogInformation("util:::: Deleted NAT policy");
            return "SUCCESS";
        }

        //****************************Delete HOST Objects ********************************************************************
        public string fmcDeleteHostObj(string authToken, ILogger log, string objId)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/object/hosts/" + objId;

            log.LogInformation("util:::: Deleting Host Object..");

            var restPost = new fmcRestApiClass();
            var response = restPost.fmcRestApiDelete(uri, authToken, log);
            if ("ERROR" == response.ToString())
            {
                log.LogError("util:::: Failed to remove Host Object ");
                return "ERROR";
            }
            log.LogInformation("util:::: Deleted host object");
            return "SUCCESS";
        }

        //****************************Create Device Group ********************************************************************
        public string fmcCreateDeviceGroup(string authToken, ILogger log, string devGroupName)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);

            string uri = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devicegroups/devicegrouprecords";
            string body = "{ \"name\": \"" + devGroupName + "\", \"type\": \"DeviceGroup\" }";

            log.LogInformation("uri: {0}", uri);
            log.LogInformation("body: {0}", body);
            log.LogInformation("util:::: Creating Device Group : {0}..", devGroupName);

            var restPost = new fmcRestApiClass();
            string response = restPost.fmcRestApiPost(uri, authToken, log, body);
            if ("ERROR" == response)
            {
                log.LogError("util:::: Failed to create device group ");
                return "ERROR";
            }
            return "SUCCESS";
        }
    }
}


//*****************************************Login to FTD via SSH****************************************
namespace ftdSshClient
{
    public class ftdSshClientClass
    {
        public string ftdSsh(string ftdIp, string lookfor, ILogger log)
        {
            string ftdUserName = System.Environment.GetEnvironmentVariable("FTD_USERNAME", EnvironmentVariableTarget.Process);
            string ftdPassword = System.Environment.GetEnvironmentVariable("FTD_PASSWORD", EnvironmentVariableTarget.Process);

            log.LogInformation("util:::: Looking for {0} in FTD {1}", lookfor, ftdIp);
            //Ignore Host Key Verification 
            Process ssh = new Process();
            ssh.StartInfo.FileName = "cmd";
            ssh.StartInfo.Arguments = " /c echo y | D:\\home\\site\\wwwroot\\ftdssh.exe " + ftdUserName + "@" + ftdIp + " -pw " + ftdPassword + " show managers";
            ssh.StartInfo.RedirectStandardOutput = true;
            ssh.StartInfo.RedirectStandardInput = true;
            ssh.StartInfo.RedirectStandardError = true;
            ssh.StartInfo.UseShellExecute = false;

            try
            {
                ssh.Start();
                string outp = ssh.StandardOutput.ReadToEnd();
                string err = ssh.StandardError.ReadToEnd();
                log.LogInformation("util:::: SSH output : {0}", outp);
                log.LogInformation("util:::: SSH error: {0}", err);
                ssh.Close();
                if (outp.Contains(lookfor))
                {
                    log.LogWarning("util:::: Found {0} in ssh output", lookfor);
                    return "AVAILABLE";
                }
                log.LogWarning("util:::: Unable to find {0}", lookfor);
                return "UNAVAILABLE";
            }
            catch
            {
                log.LogError("util:::: SSH exception");
                return "UNAVAILABLE";
            }
        }

        public string ftdSshSetHostName(string ftdIp, string hostname, ILogger log)
        {
            string ftdUserName = System.Environment.GetEnvironmentVariable("FTD_USERNAME", EnvironmentVariableTarget.Process);
            string ftdPassword = System.Environment.GetEnvironmentVariable("FTD_PASSWORD", EnvironmentVariableTarget.Process);

            log.LogInformation("util:::: Setting host name to : {0}", hostname.Replace("_", "-"));
            //Ignore Host Key Verification 
            Process ssh = new Process();
            ssh.StartInfo.FileName = "cmd";
            ssh.StartInfo.Arguments = " /c echo y | D:\\home\\site\\wwwroot\\ftdssh.exe " + ftdUserName + "@" + ftdIp + " -pw " + ftdPassword + "  configure network hostname " + hostname.Replace("_", "-");
            ssh.StartInfo.RedirectStandardOutput = true;
            ssh.StartInfo.RedirectStandardInput = true;
            ssh.StartInfo.RedirectStandardError = true;
            ssh.StartInfo.UseShellExecute = false;

            try
            {
                ssh.Start();
                string outp = ssh.StandardOutput.ReadToEnd();
                string err = ssh.StandardError.ReadToEnd();
                log.LogInformation("util:::: SSH output : {0}", outp);
                log.LogInformation("util:::: SSH error: {0}", err);
                ssh.Close();
            }
            catch
            {
                log.LogError("util:::: SSH exception");

            }
            return "SUCCESS";
        }

    }
}

//*********************************************Get FTDs Memory metrics from FMC****************************************************************
namespace getFtdMetricsFromFmc
{
    public class getMetricsClass
    {
        public string getFtdMemoryMetrics(string devId, string authToken, ILogger log)
        {
            string fmcIP = System.Environment.GetEnvironmentVariable("FMC_IP", EnvironmentVariableTarget.Process);
            string fmcUUID = System.Environment.GetEnvironmentVariable("FMC_DOMAIN_UUID", EnvironmentVariableTarget.Process);
            string errCode = "-1";
            string url = "https://" + fmcIP + "/api/fmc_config/v1/domain/" + fmcUUID + "/devices/devicerecords/" + devId + "/operational/metrics?filter=metric:memory&offset=0&limit=1&expanded=true";
            //url = url + "?offset=0&limit=1000";

            var devClient = new RestClient(url);
            var devRequest = new RestRequest(Method.GET);

            //Disable SSL certificate check
            devClient.RemoteCertificateValidationCallback = (sender, certificate, chain, sslPolicyErrors) => true;

            devRequest.AddHeader("X-auth-access-token", authToken);

            var response = devClient.Execute(devRequest);

            if (response.StatusCode.ToString() != "OK")
            {
                log.LogError("util:::: Failed get Metrics (Status Code : {0})", response.StatusCode);
                return errCode;
            }

            //  log.LogInformation("util:::: Successfully got Response for Metrics");
            log.LogDebug("util:::: response : {0}", response.Content);

            try
            {
                //convert string to json object
                JObject o = JObject.Parse(response.Content);
                foreach (var item in o["items"])
                {

                    if (("metric" == item["type"].ToString()) && ("memory" == item["id"].ToString()))
                    {
                        return item["healthMonitorMetric"]["value"].ToString();
                    }
                }
            }
            catch
            {
                log.LogInformation("util::::Error getting memory");
            }
            log.LogInformation("util::::Faile to get Metrics");
            return errCode;
        }
    }
}