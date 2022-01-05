##################################
# Provisions Networking Resources
##################################
from helpers import common

###################################
# VPC Networks and Firewall Rules
###################################

def getNetworkSelfLink(context, network):
    return f"$(ref.{context.properties[network]}.selfLink)"

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

def GetFirewallRule(context, name, network, protocol, ports, sourceRanges):
    firewall_rule = {
        'name': name,
        'type': common.FIREWALL_TYPE,
        'properties':{
            'network': network,
            'sourceRanges': sourceRanges,
            'allowed': [
                {
                    'IPProtocol': protocol,
                    'ports': ports
                }
            ],
            'targetServiceAccounts': [context.properties['service_account']]
        }
    }
    return firewall_rule

def GenerateConfig(context):
    resources = []
    networks_map = {}
    for network in context.properties['networks']:
        network_name = network['name']
        resources.append(GetNetwork(network_name, False))
        resources.append(GetSubNetwork(
            common.getSubnetName(network_name), 
            f"$(ref.{network_name}.selfLink)",
            network['cidr'],
            context.properties['region'],
            True,
            False
        ))
    
    # Management Firewall rules
    if 'mgmt_network' in context.properties:
        mgmt_self_link = getNetworkSelfLink(context, 'mgmt_network')
        resources.append(GetFirewallRule(
            context,
            'allow-ssh-mgmt',
            mgmt_self_link,
            common.TCP_PROTOCOL,
            ["22"],
            ["0.0.0.0/0"]
        ))
        resources.append(GetFirewallRule(
            context,
            'allow-https-mgmt',
            mgmt_self_link,
            common.TCP_PROTOCOL,
            ["443"],
            ["0.0.0.0/0"]
        ))
        resources.append(GetFirewallRule(
            context,
            'allow-service-port-mgmt',
            mgmt_self_link,
            common.TCP_PROTOCOL,
            [context.properties['service_port']],
            ["0.0.0.0/0"]
        ))

    # Inside Firewall rules
    if 'inside_network' in context.properties:
        inside_self_link = getNetworkSelfLink(context, 'inside_network')
        resources.append(GetFirewallRule(
            context,
            'allow-ssh-inside',
            inside_self_link,
            common.TCP_PROTOCOL,
            ["22"],
            ["0.0.0.0/0"]
        ))
        resources.append(GetFirewallRule(
            context,
            'allow-service-port-inside',
            inside_self_link,
            common.TCP_PROTOCOL,
            [context.properties['service_port']],
            ["0.0.0.0/0"]
        ))

    # Outside Firewall rules
    if 'outside_network' in context.properties:
        outside_self_link = getNetworkSelfLink(context, 'outside_network')
        resources.append(GetFirewallRule(
            context,
            'allow-ssh-outside',
            outside_self_link,
            common.TCP_PROTOCOL,
            ["22"],
            ["0.0.0.0/0"]
        ))
        resources.append(GetFirewallRule(
            context,
            'allow-service-port-outside',
            outside_self_link,
            common.TCP_PROTOCOL,
            [context.properties['service_port']],
            ["0.0.0.0/0"]
        ))

    # map for networks
    networks_map = {
        f"{network['name']}" : {
            'name': network['name'],
            'appliance_ip': network['appliance_ip'],
            'external_ip': network['external_ip'],
            'network_self_link': f"$(ref.{network['name']}.selfLink)",
            'subnet_self_link': f"$(ref.{common.getSubnetName(network['name'])}.selfLink)"
        }
        for network in context.properties['networks']
    }

    # networks_list = []
    # for network in context.properties['networks']:
    #     networks_list.append({
    #         'name': network['name'],
    #         'appliance_ip': network['appliance_ip'],
    #         'external_ip': network['external_ip'],
    #         'subnet_self_link': f"$(ref.{network['name']}.subnetworks[0])"
    #     })
        
    outputs = [
        {
            'name': 'networks_map',
            'value': networks_map
        }
    ]
    return {'resources': resources, 'outputs': outputs}