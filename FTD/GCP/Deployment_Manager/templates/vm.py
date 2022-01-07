##################################
# Provisions VM Resources
##################################
from helpers import common

def startupScript(context, index,hostname):
    if context.properties.get('startup_script'):
        script = context.properties['startup_script']
    elif context.properties.get('day_0_config'):
        if context.properties['day_0_config'] == 'oob':
            script = '\n'.join([
                '{',
                '"AdminPassword": "{0}",'.format(context.properties['admin_password']),
                '"Hostname":      "{0}"'.format(hostname),
                '}',
            ])
       
    return script # + more_steps


def networkInterfaces(context, instance_index):
    interfaces = []
    for network in context.properties['networks']:
        network_name = network['name']
        interface = {
            'network': ''.join([common.COMPUTE_URL_BASE, 'projects/',
                                context.env['project'],
                                f'/global/networks/{network_name}']),
            'subnetwork': f'$(ref.{common.getSubnetName(network_name)}.selfLink)'
        }
        if instance_index < len(network['appliance_ip']):
            interface['networkIP'] = network['appliance_ip'][instance_index]
        if network['external_ip']:
            interface['accessConfigs'] = [{
                    'name': 'External NAT',
                    'type': 'ONE_TO_ONE_NAT',
                    'networkTier': 'PREMIUM'
                }]
        interfaces.append(interface)
    return interfaces

# Provision CISCO FTD appliances
def GenerateConfig(context):
    resources = []
    instance_urls = []
    vm_external_ips = []
    for i in range(context.properties['num_instances']):
        vm_name = common.getInstanceName(context.properties['hostname'], i+1)
        final_vm_name=common.randomizeName(vm_name)
        vm = {
            'name': final_vm_name,
            'type': common.INSTANCE_TYPE,
            'properties':{
                'canIpForward': True,
                'machineType': ''.join([common.COMPUTE_URL_BASE, 'projects/',
                                  context.env['project'], '/zones/',
                                  context.properties['vm_zones'][i],
                                  f"/machineTypes/{context.properties['vm_machine_type']}"]),
                'zone': context.properties['vm_zones'][i],
                'labels': context.properties['vm_instance_labels'],
                'tags':{
                    'items': context.properties['vm_instance_tags']
                },
                'metadata': {
                    'items': [{
                        # For more ways to use startup scripts on an instance, see:
                        # https://cloud.google.com/compute/docs/startupscript
                        'key': 'startup-script',
                        'value': startupScript(context, i, vm_name) # '#!/bin/bash\npython -m SimpleHTTPServer 8080'
                    },{
                        'key': 'ssh-keys',
                        'value': context.properties['admin_ssh_pub_key']
                    },{
                        'key': 'google-monitoring-enable',
                        'value': '0'
                    },{
                        'key': 'google-logging-enable',
                        'value': '0'
                    }]
                },
                'disks': [{
                'deviceName': 'boot',
                'type': 'PERSISTENT',
                'boot': True,
                'autoDelete': True,
                'initializeParams': {
                    'sourceImage': ''.join([common.COMPUTE_URL_BASE, 'projects/',
                                            'cisco-public/global/',
                                            f"images/{context.properties['cisco_product_version']}"])}
                }],
                'serviceAccounts':[
                    {
                        'email': context.properties['service_account'],
                        'scopes': [f'{common.AUTH_URL_BASE}cloud-platform']
                    }
                ],
                'networkInterfaces': networkInterfaces(context, i)
            }
        }
        resources.append(vm)
        instance_urls.append(f'$(ref.{final_vm_name}.selfLink)')
        vm_external_ips.append(f'$(ref.{final_vm_name}.networkInterfaces[0].accessConfigs[0].natIP)')

    outputs = [{
        'name': 'instance_urls',
        'value': instance_urls,
    },{
        'name': 'vm_external_ips',
        'value': vm_external_ips
    }]
    return {'resources': resources, 'outputs': outputs}