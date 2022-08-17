import fmcapi
import logging
from pathlib import Path
import argparse
import time

def main(args):
     with fmcapi.FMC(host=args.addr, username=args.username, password=args.password, autodeploy=False, file_logging='test.txt') as fmc:
        ftd1 = fmcapi.DeviceRecords(fmc=fmc, name='ftd1')
        fg = ftd1.get()
        if ('items' not in fg):
            ftd1.delete(id=fg['id'])
        ftd2 = fmcapi.DeviceRecords(fmc=fmc, name='ftd2')
        fg = ftd2.get()
        if ('items' not in fg):
            ftd2.delete(id=fg['id'])
        acp = fmcapi.AccessPolicies(fmc=fmc, name="IAC-ACP")
        ag = acp.get()
        if ('items' not in ag):
            acp.delete(id=ag['id'])
        nat1 = fmcapi.FTDNatPolicies(fmc=fmc, name="NAT_Policy1")
        ng = nat1.get()
        if ('items' not in ng):
            nat1.delete(id=ng['id'])
        nat2 = fmcapi.FTDNatPolicies(fmc=fmc, name="NAT_Policy2")
        ng = nat2.get()
        if ('items' not in ng):
            nat2.delete(id=ng['id'])
        sz_inside = fmcapi.SecurityZones(fmc=fmc, name="inside", interfaceMode="ROUTED")
        sg = sz_inside.get()
        if ('items' not in sg):
            sz_inside.delete(id=sg['id'])
        sz_outside = fmcapi.SecurityZones(fmc=fmc, name="outside", interfaceMode="ROUTED")
        sg = sz_outside.get()
        if ('items' not in sg):
            sz_outside.delete(id=sg['id'])
        dfgw_gateway1 = fmcapi.Hosts(fmc=fmc, name="default-gateway1", value="10.0.2.1")
        dg = dfgw_gateway1.get()
        if ('items' not in dg):
            dfgw_gateway1.delete(id=dg['id'])
        dfgw_gateway2 = fmcapi.Hosts(fmc=fmc, name="default-gateway2", value="10.0.20.1")
        dg = dfgw_gateway2.get()
        if ('items' not in dg):
            dfgw_gateway2.delete(id=dg['id'])
        inside_gateway1 = fmcapi.Hosts(fmc=fmc, name="inside-gateway1", value="10.0.3.1")
        ig = inside_gateway1.get()
        if ('items' not in ig):
            inside_gateway1.delete(id=ig['id'])
        inside_gateway2 = fmcapi.Hosts(fmc=fmc, name="inside-gateway2", value="10.0.30.1")
        ig = inside_gateway2.get()
        if ('items' not in ig):
            inside_gateway2.delete(id=ig['id'])
        elb1 = fmcapi.Hosts(fmc=fmc, name="ELB1", value=args.elb1)
        eg = elb1.get()
        if ('items' not in eg):
            elb1.delete(id=eg['id'])
        elb2 = fmcapi.Hosts(fmc=fmc, name="ELB2", value=args.elb2)
        eg = elb2.get()
        if ('items' not in eg):
            elb2.delete(id=eg['id'])
        app1 = fmcapi.Networks(fmc=fmc, name="app1", value="10.0.5.0/24")
        ag = app1.get()
        if ('items' not in ag):
            app1.delete(id=ag['id'])
        app2 = fmcapi.Networks(fmc=fmc, name="app2", value="10.0.50.0/24")
        ag = app2.get()
        if ('items' not in ag):
            app2.delete(id=ag['id'])
        app_lb1 = fmcapi.Hosts(fmc=fmc, name="app-lb1", value="10.0.5.100")
        ag = app_lb1.get()
        if ('items' not in ag):
            app_lb1.delete(id=ag['id'])
        app_lb2 = fmcapi.Hosts(fmc=fmc, name="app-lb2", value="10.0.50.100")
        ag = app_lb2.get()
        if ('items' not in ag):
            app_lb2.delete(id=ag['id'])

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