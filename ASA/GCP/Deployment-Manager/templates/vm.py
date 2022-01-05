##################################
# Provisions VM Resources
##################################
from helpers import common

def startupScript(context, index):
    if context.properties.get('startup_script'):
        script = context.properties['startup_script']
    elif context.properties.get('day_0_config'):
        if context.properties['day_0_config'] == 'oob.txt':
            script = '\n'.join([
                'interface management0/0',
                'management-only',
                'nameif management',
                'security-level 0',
                'ip address dhcp setroute',
                'no shutdown',
                '!',
                'interface gig0/0',
                'nameif outside',
                'security-level 0',
                'ip address dhcp',
                'no shutdown',
                '!',
                'interface gig0/1',
                'nameif inside',
                'security-level 100',
                'ip address dhcp',
                'no shutdown',
                '!',
                'interface gig0/2',
                'nameif dmz1',
                'security-level 50',
                'ip address dhcp',
                'no shutdown',
                '!',
                'same-security-traffic permit inter-interface',
                'same-security-traffic permit intra-interface',
                '!',
                'crypto key generate rsa modulus 2048 noconfirm',
                'ssh 0 0 management',
                'ssh 0 0 outside',
                'ssh timeout 60',
                'ssh version 2',
                'aaa authentication ssh console LOCAL',
                'http server enable',
                'enable password Cisco@123',
                'username admin password cisco@123 privilege 15',
                'username admin attributes',
                'service-type admin',
                '! required config end',
                'dns domain-lookup management',
                'dns server-group DefaultDNS',
                'name-server 8.8.8.8'
            ])
        elif context.properties['day_0_config'] == 'shared-mgmt-config.txt':
            script = '\n'.join([
                'interface management0/0',
                'management-only',
                'nameif management',
                'security-level 0',
                'ip address dhcp setroute',
                'no shutdown',
                '!',
                'interface gig0/0',
                'nameif inside',
                'security-level 100',
                'ip address dhcp',
                'no shutdown',
                '!',
                'interface gig0/1',
                'nameif dmz1',
                'security-level 50',
                'ip address dhcp',
                'no shutdown',
                '!',
                'interface gig0/2',
                'nameif dmz2',
                'security-level 50',
                'ip address dhcp',
                'no shutdown',
                '!',
                'same-security-traffic permit inter-interface',
                'same-security-traffic permit intra-interface',
                '!',
                'crypto key generate rsa modulus 2048 noconfirm',
                'ssh 0 0 management',
                'ssh timeout 60',
                'ssh version 2',
                'http server enable',
                'enable password Cisco@123',
                'username admin password cisco@123 privilege 15',
                'username admin attributes',
                'service-type admin',
                '! required config end',
                'dns domain-lookup management',
                'dns server-group DefaultDNS',
                'name-server 8.8.8.8'
            ])
    # Add instances to instance groups instructions
    # zone = context.properties['vm_zones'][index]
    # ig_name = common.getInstanceGroupName(common.INSTANCE_GROUP_PREFIX, index+1)
    # instance_name = common.getInstanceName(common.INSTANCE_PREFIX, index + 1)
    # more_steps = '\n'.join([
    #     '#!/bin/bash',
    #     'echo "Adding System to instance Group"',
    #     'TOKEN=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" -H "Metadata-Flavor: Google"|cut -d \'"\' -f4)',
    #     'IG_RESPONSE=$(curl -X POST -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/json" https://www.googleapis.com/compute/v1/projects/' + context.env['project'] + '/zones/' + zone + '/instanceGroups/' + ig_name + '/addInstances -d \'{ "instances": [{ "instance": "projects/' + context.env['project'] + '/zones/' + zone + '/instances/' + instance_name + '" }] }\')',
    #     'echo "Instance Group Response:$IG_RESPONSE"'
    # ])
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

# Provision CISCO ASA appliances
def GenerateConfig(context):
    resources = []
    instance_urls = []
    vm_external_ips = []
    for i in range(context.properties['num_instances']):
        vm_name = common.getInstanceName(common.INSTANCE_PREFIX, i+1)
        vm = {
            'name': vm_name,
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
                        'value': startupScript(context, i) # '#!/bin/bash\npython -m SimpleHTTPServer 8080'
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
        instance_urls.append(f'$(ref.{vm_name}.selfLink)')
        vm_external_ips.append(f'$(ref.{vm_name}.networkInterfaces[0].accessConfigs[0].natIP)')

    outputs = [{
        'name': 'instance_urls',
        'value': instance_urls,
    },{
        'name': 'vm_external_ips',
        'value': vm_external_ips
    }]
    return {'resources': resources, 'outputs': outputs}