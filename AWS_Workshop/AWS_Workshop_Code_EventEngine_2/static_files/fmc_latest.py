import fmcapi
import time
import requests
import json
import os

addr=os.environ.get('ADDR')
is_cdfmc = os.environ.get('IS_CDFMC')
token = os.environ.get('ACCESS_TOKEN')
domainUUID = os.environ.get('DOMAIN_UUID')
username=os.environ.get('USERNAME')
password=os.environ.get('PASSWORD')
ftd1_ip=os.environ.get('FTD1')
ftd2_ip=os.environ.get('FTD2')
gw1 = os.environ.get('gw1')
gw2 = os.environ.get('gw2')

    
def lambda_handler(event, context):
    if is_cdfmc == "true":
       main_cdfmc()
    else:
       main()
    unknown()

def main_cdfmc():

    ## Access Policy

    policyurl = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/policy/accesspolicies"

    headers = {
    'accept': 'application/json',
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json'
    }

    payload = json.dumps(
    {
        "type": "AccessPolicy",
        "name": "GWLB-ACP1",
        "defaultAction": {
            "action": "BLOCK"
        }
    })

    policyresponse = requests.request("POST", policyurl, headers=headers, data=payload, verify=False)

    pr = policyresponse.json()

    ##Zones

    zoneurl = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/object/securityzones?bulk=true"
    
    payload = json.dumps(
        [
            {
                "type": "SecurityZone",
                "name": "outside",
                "interfaceMode": "ROUTED",
            },
            {
                "type": "SecurityZone",
                "name": "inside",
                "interfaceMode": "ROUTED",
            },
            {
                "type": "SecurityZone",
                "name": "vni",
                "interfaceMode": "ROUTED",
            }
        ])
    
    zonerespone = requests.request("POST", zoneurl, headers=headers, data=payload, verify=False)

    z = zonerespone.json()
    z = z['items']

    ## Host Objects

    hosturl = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/object/hosts?bulk=true"

    payload = json.dumps(
        [
            {
                "type": "Host",
                "value": "169.254.169.254",
                "name": "aws_metadata_server"
            },
            {
                "type": "Host",
                "value": gw1,
                "name": "inside-gateway1"
            },
            {
                "type": "Host",
                "value": gw2,
                "name": "inside-gateway2"
            }
        ]
    )

    hostresponse = requests.request("POST", hosturl, headers=headers, data=payload, verify=False)

    h = hostresponse.json()
    h = h['items']
    print(h)
    
    ## Port Objects

    porturl = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/object/protocolportobjects?bulk=true"

    payload = json.dumps(
        [
            {
                "name": "aws_ssh",
                "protocol": "TCP",
                "port": 22,
                "type": "ProtocolPortObject"
            },
            {
                "name": "aws_http",
                "protocol": "TCP",
                "port": 80,
                "type": "ProtocolPortObject"
            }
        ]
    )

    portresponse = requests.request("POST", porturl, headers=headers, data=payload, verify=False)

    ports = portresponse.json()
    ports = ports['items']

    ## Access Rule

    aclurl = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/policy/accesspolicies/"+pr['id']+"/accessrules"

    payload = json.dumps(
        {
            "action": "ALLOW",
            "enabled": True,
            "type": "AccessRule",
            "name": "Rule1",
            "sendEventsToFMC": False
        })

    ruleresponse = requests.request("POST", aclurl, headers=headers, data=payload, verify=False)

    r = ruleresponse.json()

    ## Device 1

    deviceurl = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/devices/devicerecords"
    payload = json.dumps(
        {
            "name": "ftd1",
            "hostName": ftd1_ip,
            "regKey": "cisco",
            "natID": "cisco",
            "type": "Device",
            "accessPolicy": {
                "id": pr["id"],
                "type": "AccessPolicy"
            }
        })

    device1response = requests.request("PUT", deviceurl, headers=headers, data=payload, verify=False)

    time.sleep(300)

    d1response = requests.request("GET", deviceurl+"?filter=name:ftd1", headers=headers, verify=False)

    d1 = d1response.json()
    
    d1 = d1['items'][0]

    ## Device 1 Physical interface

    phyurl = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/devices/devicerecords/"+d1['id']+"/physicalinterfaces"

    phyresponse = requests.request("GET", phyurl, headers=headers, verify=False)

    phr = phyresponse.json()

    items = phr['items']

    print(items)
    
    #for item in items:
    #    if item['name'] == "TenGigabitEthernet0/0":
    #        phy1id = item['id']
    #    if item['name'] == "TenGigabitEthernet0/1":
    #        phy2id = item['id']
    
    phy1id = items[1]['id']
    
    phy1url = phyurl+"/"+phy1id
    
    print(phy1url)

    payload = json.dumps({
        "type": "PhysicalInterface",
        "enabled": True,
        "name": "TenGigabitEthernet0/0",
        "mode": "NONE",
        "ipv4": {
            "dhcp": {
                "enableDefaultRouteDHCP": True,
                "dhcpRouteMetric": 1
            }
        },
        "ifname": "outside",
        "id": phy1id,
        "securityZone": {
            "name": z[0]["name"],
            "id": z[0]["id"],
            "type": z[0]["type"]
        }
    })

    phy1response = requests.request("PUT", phy1url, headers=headers, data=payload, verify=False)
    
    print(phy1response.json())

    time.sleep(10)

    ## Device 2

    deviceurl2 = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/devices/devicerecords"

    payload = json.dumps({
            "name": "ftd2",
            "hostName": ftd2_ip,
            "regKey": "cisco",
            "natID": "cisco",
            "type": "Device",
            "accessPolicy": {
                "id": pr["id"],
                "type": "AccessPolicy"
            }
        })

    device2response = requests.request("PUT", deviceurl2, headers=headers, data=payload, verify=False)

    time.sleep(300)

    d2response = requests.request("GET", deviceurl2+"?filter=name:ftd2", headers=headers, verify=False)

    d2 = d2response.json()
    
    d2 = d2['items'][0]

    ## Device 2 Physical interface

    phyurl2 = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/devices/devicerecords/"+d2['id']+"/physicalinterfaces"

    phy2response = requests.request("GET", phyurl2, headers=headers, verify=False)

    phr2 = phy2response.json()

    items = phr2['items']

    for item in items:
        if item['name'] == "TenGigabitEthernet0/0":
            phy1id = item['id']
        if item['name'] == "TenGigabitEthernet0/1":
            phy2id = item['id']
    
    phy1url = "https://"+addr+"/api/fmc_config/v1/domain/"+domainUUID+"/devices/devicerecords/"+d2['id']+"/physicalinterfaces/"+phy1id

    payload = json.dumps({
        "type": "PhysicalInterface",
        "enabled": True,
        "name": "TenGigabitEthernet0/0",
        "mode": "NONE",
        "ipv4": {
            "dhcp": {
                "enableDefaultRouteDHCP": "true",
                "dhcpRouteMetric": 1
            }
        },
        "ifname": "outside",
        "id": phy1id,
        "securityZone": {
            "name": z[0]["name"],
            "id": z[0]["id"],
            "type": z[0]["type"]
        }
    })

    phy1response = requests.request("PUT", phy1url, headers=headers, data=payload, verify=False)
    
    print(phy1response.json())

    time.sleep(10)

def main():
    print("IN main-aws")
    
    with fmcapi.FMC(host=addr, username=username, password=password, autodeploy=False) as fmc:
        
        #Access Policy
        acp = fmcapi.AccessPolicies(fmc=fmc, name="GWLB-ACP1")
        acp.defaultAction = "BLOCK"
        acp.post()

        #SecurityZone 
        sz_outside = fmcapi.SecurityZones(fmc=fmc, name="outside", interfaceMode="ROUTED")
        sz_outside.post()

        #SecurityZone 
        sz_inside = fmcapi.SecurityZones(fmc=fmc, name="inside", interfaceMode="ROUTED")
        sz_inside.post()

        #SecurityZone 
        sz_vni = fmcapi.SecurityZones(fmc=fmc, name="vni", interfaceMode="ROUTED")
        sz_vni.post()

        aws_metadata_server = fmcapi.Hosts(fmc=fmc, name="aws_metadata_server", value="169.254.169.254") # #Outside subnet #"172.16.3.119"
        aws_metadata_server.post()

        acp_rule = fmcapi.AccessRules(fmc=fmc, acp_id=acp.id, name="Rule-1")
        acp_rule.logEnd = True
        acp_rule.sendEventsToFMC = True
        acp_rule.enabled = True
        acp_rule.action = "ALLOW"
        acp_rule.destination_network(action="add", name="aws_metadata_server")
        acp_rule.destination_port(action="add", name="HTTP")
        acp_rule.post()



        #Gateway1 Host Object
        dfgw_gateway1 = fmcapi.Hosts(fmc=fmc, name="inside-gateway1", value=gw1)
        dfgw_gateway1.post()
        
        #Gateway2 Host Object
        dfgw_gateway2 = fmcapi.Hosts(fmc=fmc, name="inside-gateway2", value=gw2)
        dfgw_gateway2.post()
        
       
       
        #NAT Policy 1
        nat1 = fmcapi.FTDNatPolicies(fmc=fmc, name="NAT_Policy")
        nat1.post()
        
        #NAT Rule 1
        manualnat1 = fmcapi.ManualNatRules(fmc=fmc)
        manualnat1.natType = "STATIC"
        manualnat1.original_source("any-ipv4")
        manualnat1.original_destination_port("SSH")
        manualnat1.translated_destination_port("HTTP")
        manualnat1.translated_destination(aws_metadata_server.name)
        manualnat1.interfaceInOriginalDestination = True
        manualnat1.interfaceInTranslatedSource = True
        manualnat1.source_intf(name=sz_outside.name)
        manualnat1.destination_intf(name=sz_inside.name)
        manualnat1.nat_policy(name=nat1.name)
        manualnat1.enabled = True
        manualnat1.post()

        #NAT Policy 2
        nat2 = fmcapi.FTDNatPolicies(fmc=fmc, name="NAT_Policy-2")
        nat2.post()
        
        #NAT Rule 1
        manualnat2 = fmcapi.ManualNatRules(fmc=fmc)
        manualnat2.natType = "STATIC"
        manualnat2.original_source("any-ipv4")
        manualnat2.original_destination_port("SSH")
        manualnat2.translated_destination_port("HTTP")
        manualnat2.translated_destination(aws_metadata_server.name)
        manualnat2.interfaceInOriginalDestination = True
        manualnat2.interfaceInTranslatedSource = True
        manualnat2.source_intf(name=sz_outside.name)
        manualnat2.destination_intf(name=sz_inside.name)
        manualnat2.nat_policy(name=nat2.name)
        manualnat2.enabled = True
        manualnat2.post()
        
      #Register Device 1
        ftd1 = fmcapi.DeviceRecords(fmc=fmc)
        ftd1.hostName = ftd1_ip
        ftd1.regKey = "cisco"
        ftd1.acp(name="GWLB-ACP1")
        ftd1.name = "ftd1"
        ftd1.type = 'Device'
        ftd1.natID = 'cisco'
        ftd1.licensing(action="add", name="ESSENTIALS")
        ftd1.post(post_wait_time=300)
        
       
        #interfaces ftd1

        ftd1_g00 = fmcapi.PhysicalInterfaces(fmc=fmc, device_name=ftd1.name)
        ftd1_g00.get(name="TenGigabitEthernet0/0")
        ftd1_g00.enabled = True
        ftd1_g00.ifname = "outside"
        ftd1_g00.dhcp(True, 1)
        ftd1_g00.sz(name="outside")
        ftd1_g00.put(put_wait_time=3)

        ftd1_g01 = fmcapi.PhysicalInterfaces(fmc=fmc, device_name=ftd1.name)
        ftd1_g01.get(name="TenGigabitEthernet0/1")
        ftd1_g01.enabled = True
        ftd1_g01.ifname = "inside"
        ftd1_g01.dhcp(True, 1)
        ftd1_g01.sz(name="inside")
        ftd1_g01.put(put_wait_time=3)

        #FTD1 Route
        rt = fmcapi.IPv4StaticRoutes(fmc=fmc, device_name=ftd1.name)
        rt.networks(action="add", networks=["aws_metadata_server"])
        rt.gw(name="inside-gateway1")
        rt.interfaceName = "inside"
        rt.post()

        #Register Device 2
        ftd2 = fmcapi.DeviceRecords(fmc=fmc)
        ftd2.hostName = ftd2_ip
        ftd2.regKey = "cisco"
        ftd2.acp(name="GWLB-ACP1")
        ftd2.name = "ftd2"
        ftd2.type = 'Device'
        ftd2.natID = 'cisco'
        ftd2.licensing(action="add", name="BASE")
        ftd2.post(post_wait_time=300)
       
         #interfaces ftd2
        ftd2_g00 = fmcapi.PhysicalInterfaces(fmc=fmc, device_name=ftd2.name)
        ftd2_g00.get(name="TenGigabitEthernet0/0")
        ftd2_g00.enabled = True
        ftd2_g00.ifname = "outside"
        ftd2_g00.dhcp(True, 1)
        ftd2_g00.sz(name="outside")
        ftd2_g00.put(put_wait_time=3)

        ftd2_g01 = fmcapi.PhysicalInterfaces(fmc=fmc, device_name=ftd2.name)
        ftd2_g01.get(name="TenGigabitEthernet0/1")
        ftd2_g01.enabled = True
        ftd2_g01.ifname = "inside"
        ftd2_g01.dhcp(True, 1)
        ftd2_g01.sz(name="inside")
        ftd2_g01.put(put_wait_time=3)

        #FTD2 Route
        rt = fmcapi.IPv4StaticRoutes(fmc=fmc, device_name=ftd2.name)
        rt.networks(action="add", networks=["aws_metadata_server"])
        rt.gw(name="inside-gateway2")
        rt.interfaceName = "inside"
        rt.post()
         
        # Associate NAT policy 1 with ftd1.
        devices = [{"name": ftd1.name, "type": "device"}]
        assign_nat_policy1 = fmcapi.PolicyAssignments(fmc=fmc)
        assign_nat_policy1.ftd_natpolicy(name=nat1.name, devices=devices)
        assign_nat_policy1.post(post_wait_time=3)
        # Associate NAT policy 2 with ftd2.
        devices = [{"name": ftd2.name, "type": "device"}]
        assign_nat_policy2 = fmcapi.PolicyAssignments(fmc=fmc)
        assign_nat_policy2.ftd_natpolicy(name=nat2.name, devices=devices)
        assign_nat_policy2.post(post_wait_time=3)


def unknown():
    host = addr
    if is_cdfmc == "true":
        headers = {
            'accept': 'application/json',
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json'
        }
    else:
        username = os.environ.get('USERNAME')
        password = os.environ.get('PASSWORD')
        print(host)
        print(username)
        print(password)

        #####DomainUUID and Token

        domainurl = "https://"+host+"//api/fmc_platform/v1/auth/generatetoken"
        payload0={}

        domainresponse = requests.request("POST", domainurl,data=payload0, auth=(username ,password), verify=False)

        token1 = domainresponse.headers['X-auth-access-token']
        #domainUUID  =  domainresponse.headers['DOMAIN_UUID']


        #####Defining Headers

        headers = {
            'accept': 'application/json',
            'X-auth-access-token': token1,
            'Content-Type': 'application/json'
        }
        

    ###### Base url

    baseurl = "https://"+host+"/api/fmc_config/v1/domain/"+domainUUID+"/devices/devicerecords" 

    

    #####Device ID-1
    deviceurl1 = baseurl 
    devicepayload1={}
    deviceresponse1 = requests.request("GET", deviceurl1, headers=headers, data=devicepayload1, verify=False)
    json_data1 = json.loads(deviceresponse1.text)
    deviceID1 = json_data1["items"][0]["id"]
    deviceID2 = json_data1["items"][1]["id"]
    print(deviceID1)
    print(deviceID2)

    #####Physical Interface ID
    phyurl = baseurl + "/" + deviceID1 + "/physicalinterfaces?offset=1&limit=1"
    phypayload={}
    phyresponse = requests.request("GET", phyurl, headers=headers, data=phypayload, verify=False)
    json_phyinter = json.loads(phyresponse.text)
    phyID1 = json_phyinter["items"][0]["id"]
    print("----------------------Printing phyID--------------------------")
    print(phyID1)

    #print("phy id1")
    phyurl2 = baseurl + "/" + deviceID2 + "/physicalinterfaces?offset=1&limit=1"
    phyresponse2 = requests.request("GET", phyurl2, headers=headers, data=phypayload, verify=False)
    json_phyinter2 = json.loads(phyresponse2.text)
    phyID2 = json_phyinter2["items"][0]["id"]
    print(phyID2)
    # print("phy id2")

    #####VTEP
    vtepurl = baseurl + "/" + deviceID1 + "/vteppolicies"
    payload = json.dumps({
    "nveEnable": True,
    "vtepEntries": [
        {
        "sourceInterface": {
            "name": "TenGigabitEthernet0/0",
            "type": "PhysicalInterface",
            "id": phyID1
        },
        "nveVtepId": 1,
        "nveDestinationPort": 6081,
        "nveEncapsulationType": "GENEVE"
        }
    ],
    "type": "VTEPPolicy"
    })
    print("----------------------Printing Vtepresponse--------------------------")
    vtepresponse = requests.request("POST", vtepurl, headers=headers, data=payload, verify=False)
    #print(vtepresponse.text)

    vtepurl2 = baseurl + "/" + deviceID2 + "/vteppolicies"
    vteppayload2 = json.dumps({
    "nveEnable": True,
    "vtepEntries": [
        {
        "sourceInterface": {
            "name": "TenGigabitEthernet0/0",
            "type": "PhysicalInterface",
            "id": phyID2
        },
        "nveVtepId": 1,
        "nveDestinationPort": 6081,
        "nveEncapsulationType": "GENEVE"
        }
    ],
    "type": "VTEPPolicy"
    })

    vtepresponse2 = requests.request("POST", vtepurl2, headers=headers, data=vteppayload2, verify=False)
    #print(vtepresponse2.text)

    ######Security Zone ID

    szurl = "https://"+host+"/api/fmc_config/v1/domain/"+domainUUID+"/object/securityzones"
    szpayload={}
    szID = ""
    szresponse = requests.request("GET", szurl, headers=headers, data=szpayload, verify=False)
    json_sz = json.loads(szresponse.text)
    for sz in json_sz["items"]:
        if sz["name"] == "vni":
            szID = sz["id"]
            break
    print("----------------------Printing SZID--------------------------")
    print(szID)

    ######VNI
    vniurl = baseurl + "/" + deviceID1 + "/vniinterfaces"
    vniurl2 = baseurl + "/" + deviceID2 + "/vniinterfaces"
    payload2 = json.dumps({
    "type": "VNIInterface",
    "vniId": 5,
    "mode": "NONE",
    "vtepID": 1,
    "enabled": True,
    "ifname": "vni",
    "enableProxy": True,
    "securityZone": {
        "id": szID,
        "type": "SecurityZone"
    }
    })
    vniresponse = requests.request("POST", vniurl, headers=headers, data=payload2, verify=False)
    print("----------------------VNI ID--------------------------")
    print(vniresponse.text)
    vniresponse2 = requests.request("POST", vniurl2, headers=headers, data=payload2, verify=False)
    print(vniresponse2.text)

    #### GET_Deployable devices

    getdeviceurl = "https://"+host+"/api/fmc_config/v1/domain/"+domainUUID+"/deployment/deployabledevices"
    getdevicepayload={}
    getdeviceresponse = requests.request("GET", getdeviceurl, headers=headers, data=getdevicepayload, verify=False)
    print(getdeviceresponse.text)
    print("Version---")
    json_version = json.loads(getdeviceresponse.text)
    version = json_version["items"][0]["version"]
    print(version)

    #### Deploying Devices

    deployurl = "https://"+host+"/api/fmc_config/v1/domain/"+domainUUID+"/deployment/deploymentrequests"
    deploypayload = json.dumps({
      "type": "DeploymentRequest",
      "version": version,
      "forceDeploy": False,
      "ignoreWarning": True,
      "deviceList": [
        deviceID1,
        deviceID2
      ],
      "deploymentNote": "--Deployed using RestAPI--"
    })

    deployresponse = requests.request("POST", deployurl, headers=headers, data=deploypayload, verify=False)
    print(deployresponse.text)