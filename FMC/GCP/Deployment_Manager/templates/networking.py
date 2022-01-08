##################################
# Provisions Networking Resources
##################################
from helpers import common

##############################
# VPC Networks and Firewall Rules
##############################

def GetNetwork(name, autoCreateSubnetworks):
    network = {
        'name': name,
        'type': common.NETWORK_TYPE,
        'properties':{
            'autoCreateSubnetworks': autoCreateSubnetworks,
            "routingConfig": {
                "routingMode": 'GLOBAL'
            }
        }
    }
    return network

def GetSubNetwork(name, network, ipCidrRange, region, privateAccess, flowLogs):
    subnet = {
        'name': name,
        'type': common.SUBNETWORK_TYPE,
        'properties':{
            'network': network,
            'ipCidrRange': ipCidrRange,
            'region': region,
            'privateIpGoogleAccess': privateAccess,
            'enableFlowLogs': flowLogs
        }
    }
    return subnet


def GenerateConfig(context):
    resources = []
    network_name = context.properties['network']
    resources.append(GetNetwork(network_name, False))
    resources.append(GetSubNetwork(
            common.getSubnetName(network_name), 
            f"$(ref.{network_name}.selfLink)",
            context.properties['network_subnet_cidr_range'],
            context.properties['region'],
            True,
            False
    ))
    
    outputs = [
        {
            'name': 'network_link',
            'value': f"{common.getNetworkSelfLink(network_name)}"
        },
        {
            'name': 'subnet_link',
            'value': f"$(ref.{common.getSubnetName(network_name)}.selfLink)"
        },
    ]
    return {'resources': resources, 'outputs': outputs}