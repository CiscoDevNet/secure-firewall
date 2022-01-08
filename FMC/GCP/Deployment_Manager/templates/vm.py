##################################
# Provisions VM Resources
##################################
from helpers import common

# Constants
INSTANCE_TYPE = 'compute.v1.instance'
COMPUTE_URL_BASE = 'https://www.googleapis.com/compute/v1/'
AUTH_URL_BASE = 'https://www.googleapis.com/auth/'
INSTANCE_PREFIX = 'fmc'

def startupScript(context, index,hostname):
    if context.properties.get('startup_script'):
        script = context.properties['startup_script']
    elif context.properties.get('day_0_config'):
        if context.properties['day_0_config'] == 'fmcv':
            script = '\n'.join([
                '{',
                '"AdminPassword": "{0}",'.format(context.properties['admin_password']),
                '"Hostname":      "{0}"'.format(hostname),
                '}',
            ])
    return script


def networkInterfaces(context, instance_index):
    interfaces = []
    interface = {
        'subnetwork': context.properties['subnet_url']
    }
    interface['networkIP'] = context.properties['appliance_ips'][instance_index]
    interface['accessConfigs'] = [{
            'name': 'External NAT',
            'type': 'ONE_TO_ONE_NAT',
            'networkTier': 'PREMIUM'
        }]
    interfaces.append(interface)
    return interfaces


# Provision CISCO appliances
def GenerateConfig(context):
    resources = []
    instance_urls = []
    instance_ips = []
    for i in range(context.properties['num_instances']):
        vm_name = common.getInstanceName(context.properties['hostname'], i+1)
        final_vm_name=common.randomizeName(vm_name)
        vm = {
            'name': final_vm_name,
            'type': INSTANCE_TYPE,
            'properties':{
                'canIpForward': True,
                'machineType': ''.join([COMPUTE_URL_BASE, 'projects/',
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
                    }]
                },
                'disks': [{
                'deviceName': 'boot',
                'type': 'PERSISTENT',
                'boot': True,
                'autoDelete': True,
                'initializeParams': {
                    'diskSizeGb': context.properties['boot_disk_size'],
                    'sourceImage': ''.join([COMPUTE_URL_BASE, 'projects/',
                                            'cisco-public/global/',
                                            f"images/{context.properties['cisco_product_version']}"])}
                }],
                'serviceAccounts':[
                    {
                        'email': context.properties['service_account'],
                        'scopes': [f'{AUTH_URL_BASE}cloud-platform']
                    }
                ],
                'networkInterfaces': networkInterfaces(context, i)
            }
        }
        resources.append(vm)
        instance_urls.append(f'$(ref.{final_vm_name}.selfLink)')
        instance_ips.append(f'$(ref.{final_vm_name}.networkInterfaces[0].accessConfigs[0].natIP)')

    outputs = [
        {
           'name': 'instance_urls',
           'value': instance_urls,
        },
        { 'name': 'instance_ips',
          'value': instance_ips
        }
    ]
    return {'resources': resources, 'outputs': outputs}