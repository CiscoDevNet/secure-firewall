import fmcapi
import logging
from pathlib import Path
import argparse
import time

def main(args):
    with fmcapi.FMC(host=args.addr, username=args.username, password=args.password, autodeploy=False, file_logging='test.txt') as fmc:
        #Access Policy
        acp = fmcapi.AccessPolicies(fmc=fmc, name="IAC-ACP")
        acp.defaultAction = "BLOCK"
        acp.post()
        #Security Zones
        sz_inside = fmcapi.SecurityZones(fmc=fmc, name="inside", interfaceMode="ROUTED")
        sz_inside.post()
        sz_outside = fmcapi.SecurityZones(fmc=fmc, name="outside", interfaceMode="ROUTED")
        sz_outside.post()
        #Gateway1 Host Object
        dfgw_gateway1 = fmcapi.Hosts(fmc=fmc, name="default-gateway1", value="10.0.2.1")
        dfgw_gateway1.post()
        #Gateway2 Host Object
        dfgw_gateway2 = fmcapi.Hosts(fmc=fmc, name="default-gateway2", value="10.0.20.1")
        dfgw_gateway2.post()
        #Inside Gateway1 Host Object
        inside_gateway1 = fmcapi.Hosts(fmc=fmc, name="inside-gateway1", value="10.0.3.1")
        inside_gateway1.post()
        #Inside Gateway2 Host Object
        inside_gateway2 = fmcapi.Hosts(fmc=fmc, name="inside-gateway2", value="10.0.30.1")
        inside_gateway2.post()
        #ELB interface 1 IP
        elb1 = fmcapi.Hosts(fmc=fmc, name="ELB1", value=args.elb1)
        elb1.post()
        #ELB interface 2 IP
        elb2 = fmcapi.Hosts(fmc=fmc, name="ELB2", value=args.elb2)
        elb2.post()
        #APP1 Network Object
        app1 = fmcapi.Networks(fmc=fmc, name="app1", value="10.0.5.0/24")
        app1.post()
        #APP2 Network Object
        app2 = fmcapi.Networks(fmc=fmc, name="app2", value="10.0.50.0/24")
        app2.post()
        #APP LB IP Address 1
        app_lb1 = fmcapi.Hosts(fmc=fmc, name="app-lb1", value="10.0.5.100")
        app_lb1.post()
        #APP LB IP Address 2
        app_lb2 = fmcapi.Hosts(fmc=fmc, name="app-lb2", value="10.0.50.100")
        app_lb2.post()
        # Create ACP Rule to permit outside traffic to web server.
        acprule = fmcapi.AccessRules(fmc=fmc,acp_name=acp.name,name="To Web Server",action="ALLOW",enabled=True)
        acprule.source_zone(action="add", name=sz_outside.name)
        acprule.destination_zone(action="add", name=sz_inside.name)
        acprule.destination_network(action="add", name=app_lb1.name)
        acprule.destination_network(action="add", name=app_lb2.name)
        acprule.logEnd = False
        acprule.post()
        #NAT Policy 1
        nat1 = fmcapi.FTDNatPolicies(fmc=fmc, name="NAT_Policy1")
        nat1.post()
        #NAT Policy 2
        nat2 = fmcapi.FTDNatPolicies(fmc=fmc, name="NAT_Policy2")
        nat2.post()
        #NAT Rule 1
        manualnat1 = fmcapi.ManualNatRules(fmc=fmc)
        manualnat1.natType = "STATIC"
        manualnat1.original_source(elb1.name)
        manualnat1.original_destination_port("HTTP")
        manualnat1.translated_destination_port("HTTP")
        manualnat1.translated_destination(app_lb1.name)
        manualnat1.interfaceInOriginalDestination = True
        manualnat1.interfaceInTranslatedSource = True
        manualnat1.source_intf(name=sz_outside.name)
        manualnat1.destination_intf(name=sz_inside.name)
        manualnat1.nat_policy(name=nat1.name)
        manualnat1.enabled = True
        manualnat1.post()
        #NAT Rule 2
        manualnat2 = fmcapi.ManualNatRules(fmc=fmc)
        manualnat2.natType = "STATIC"
        manualnat2.original_source(elb2.name)
        manualnat2.original_destination_port("HTTP")
        manualnat2.translated_destination_port("HTTP")
        manualnat2.translated_destination(app_lb2.name)
        manualnat2.interfaceInOriginalDestination = True
        manualnat2.interfaceInTranslatedSource = True
        manualnat2.source_intf(name=sz_outside.name)
        manualnat2.destination_intf(name=sz_inside.name)
        manualnat2.nat_policy(name=nat2.name)
        manualnat2.enabled = True
        manualnat2.post()
        #Register Device 1
        ftd1 = fmcapi.DeviceRecords(fmc=fmc)
        ftd1.hostName = "10.0.1.10"
        ftd1.regKey = "cisco"
        ftd1.acp(name="IAC-ACP")
        ftd1.name = "ftd1"
        ftd1.licensing(action="add", name="BASE")
        ftd1.post(post_wait_time=200)
        #Register Device 2
        ftd2 = fmcapi.DeviceRecords(fmc=fmc)
        ftd2.hostName = "10.0.10.10"
        ftd2.regKey = "cisco"
        ftd2.acp(name="IAC-ACP")
        ftd2.name = "ftd2"
        ftd2.licensing(action="add", name="BASE")
        ftd2.post(post_wait_time=200)
        #interfaces ftd1
        ftd1_g00 = fmcapi.PhysicalInterfaces(fmc=fmc, device_name=ftd1.name)
        ftd1_g00.get(name="TenGigabitEthernet0/0")
        ftd1_g00.enabled = True
        ftd1_g00.ifname = "outside"
        ftd1_g00.dhcp(True, 1)
        ftd1_g00.sz(name="outside")
        ftd1_g00.put(put_wait_time=3)
        #interfaces ftd2
        ftd1_g01 = fmcapi.PhysicalInterfaces(fmc=fmc, device_name=ftd1.name)
        ftd1_g01.get(name="TenGigabitEthernet0/1")
        ftd1_g01.enabled = True
        ftd1_g01.ifname = "inside"
        ftd1_g01.dhcp(False, 1)
        ftd1_g01.sz(name="inside")
        ftd1_g01.put(put_wait_time=3)
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
        ftd2_g01.dhcp(False, 1)
        ftd2_g01.sz(name="inside")
        ftd2_g01.put(put_wait_time=3)
        #static route - ftd1
        web_route1 = fmcapi.IPv4StaticRoutes(fmc=fmc, name="app_route1")
        web_route1.device(device_name=ftd1.name)
        web_route1.networks(action="add", networks=["app1"])
        web_route1.gw(name=inside_gateway1.name)
        web_route1.interfaceName = ftd1_g01.ifname
        web_route1.metricValue = 1
        web_route1.post(post_wait_time=3)
        #static route - ftd2
        web_route2 = fmcapi.IPv4StaticRoutes(fmc=fmc, name="app_route2")
        web_route2.device(device_name=ftd2.name)
        web_route2.networks(action="add", networks=["app2"])
        web_route2.gw(name=inside_gateway2.name)
        web_route2.interfaceName = ftd2_g01.ifname
        web_route2.metricValue = 1
        web_route2.post(post_wait_time=3)
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

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--addr", required=True, help="Address of Cisco FMC")
    parser.add_argument("--username", required=True, help="Username of Cisco FMC")
    parser.add_argument("--password", required=True, help="Password of Cisco FMC")
    parser.add_argument("--elb1", required=True, help="ELB network interface IP in AZ 1")
    parser.add_argument("--elb2", required=True, help="ELB network interface IP in AZ 2")
    #parser.add_argument("--delete", nargs='?', const=True, type=bool, help="Argument to be used if the rules should be deleted")
    args = parser.parse_args()
    main(args)