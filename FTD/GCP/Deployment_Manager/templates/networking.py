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
        'name': common.randomizeName(name),
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

def GetFirewallRuleAllowAll(context, name, network, protocol):
    firewall_rule = {
        'name': common.randomizeName(name),
        'type': common.FIREWALL_TYPE,
        'properties':{
            'network': network,
            'sourceRanges': ["0.0.0.0/0"],
            'allowed': [
                {
                    'IPProtocol': protocol
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
        'allow-tunnel-mgmt',
        mgmt_self_link,
        common.TCP_PROTOCOL,
        ["8305"],
        ["0.0.0.0/0"]
    ))

    # Inside Firewall rules
    inside_self_link = getNetworkSelfLink(context, 'inside_network')
    resources.append(GetFirewallRuleAllowAll(
        context,
        'allow-tcp-inside',
        inside_self_link,
        common.TCP_PROTOCOL        
    ))
    # inside_self_link = getNetworkSelfLink(context, 'inside_network')
    # resources.append(GetFirewallRule(
    #     context,
    #     'allow-ssh-inside',
    #     inside_self_link,
    #     common.TCP_PROTOCOL,
    #     ["22"],
    #     ["0.0.0.0/0"]
    # ))
    # resources.append(GetFirewallRule(
    #     context,
    #     'allow-tunnel-inside',
    #     inside_self_link,
    #     common.TCP_PROTOCOL,
    #     ["8305"],
    #     ["0.0.0.0/0"]
    # ))


    # Outside Firewall rules
    outside_self_link = getNetworkSelfLink(context, 'outside_network')
    resources.append(GetFirewallRuleAllowAll(
        context,
        'allow-tcp-outside',
        outside_self_link,
        common.TCP_PROTOCOL 
    ))
    # resources.append(GetFirewallRule(
    #     context,
    #     'allow-ssh-outside',
    #     outside_self_link,
    #     common.TCP_PROTOCOL,
    #     ["22"],
    #     ["0.0.0.0/0"]
    # ))
    # resources.append(GetFirewallRule(
    #     context,
    #     'allow-tunnel-outside',
    #     outside_self_link,
    #     common.TCP_PROTOCOL,
    #     ["8305"],
    #     ["0.0.0.0/0"]
    # ))

    # DMZ Firewall rules
    dmz_self_link = getNetworkSelfLink(context, 'dmz_network')
    resources.append(GetFirewallRuleAllowAll(
        context,
        'allow-tcp-dmz',
        dmz_self_link,
        common.TCP_PROTOCOL 
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

    outputs = [
        {
            'name': 'networks_map',
            'value': networks_map
        }
    ]
    return {'resources': resources, 'outputs': outputs}