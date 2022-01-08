##################################
# Provisions Networking Resources
##################################
from helpers import common

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



"""Creates the firewall."""
def GenerateConfig(context):

    resources = []
    # Management Firewall rules
    mgmt_self_link = context.properties['network_url']
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
        'allow-sftunnel-mgmt',
        mgmt_self_link,
        common.TCP_PROTOCOL,
        ["8305"],
        ["0.0.0.0/0"]
    ))
    return {'resources': resources}
