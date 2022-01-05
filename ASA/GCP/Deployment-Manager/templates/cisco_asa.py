def GenerateConfig(context):
    resources = []
    haEnabled = context.properties['num_instances'] > 1
    # Enabling services
    services = {
        'name': 'enable_services',
        'type': 'enable_services.py',
        'properties': {
            'services': context.properties['services']
        }
    }
    # Networking provisioning
    networking = {
        'name': 'networking',
        'type': 'networking.py',
        'properties': {
            'ha_enabled': haEnabled,
            'region': context.properties['region'],
            'mgmt_network': context.properties['mgmt_network'],
            'custom_route_tag': context.properties['custom_route_tag'],
            # Using email from service_account's output
            'service_account': '$(ref.service_accounts.email)',
            'service_port': context.properties['service_port'],
            'networks': context.properties['networks']
        }
    }
    # Additional networtks
    if 'inside_network' in context.properties:
        networking['properties']['inside_network'] = context.properties['inside_network']
    if 'outside_network' in context.properties:
        networking['properties']['outside_network'] = context.properties['outside_network']
    if 'dmz1_network' in context.properties:
        networking['properties']['dmz1_network'] = context.properties['dmz1_network']
    if 'dmz2_network' in context.properties:
        networking['properties']['dmz2_network'] = context.properties['dmz2_network']
    # Service Account
    sa = {
        'name': 'service_accounts',
        'type': 'service_accounts.py',
        'properties': {
            'account_id': context.properties['account_id'],
            'display_name': context.properties['display_name']
        },
        'metadata': {
            'dependsOn': ['enable_services']
        }
    }
    # Appliance VMs
    vm = {
        'name': 'vm',
        'type': 'vm.py',
        'properties': {
            'vm_zones': context.properties['vm_zones'],
            'num_instances': context.properties['num_instances'],
            'cisco_product_version': context.properties['cisco_product_version'],
            'vm_machine_type': context.properties['vm_machine_type'],
            'vm_instance_labels': context.properties['vm_instance_labels'],
            'vm_instance_tags': context.properties['vm_instance_tags'],
            'admin_ssh_pub_key': context.properties['admin_ssh_pub_key'],
            'day_0_config': context.properties['day_0_config'],
            'service_account': '$(ref.service_accounts.email)',
            'networks': context.properties['networks']
        },
        'metadata': {
            'dependsOn': ['networking']
        }
    }
    # Prepare all resources to be provisioned
    resources += [services, sa, networking, vm]
    outputs = [{
        'name': 'vm_urls',
        'value': '$(ref.vm.instance_urls)'
    },{
        'name': 'vm_external_ips',
        'value': '$(ref.vm.vm_external_ips)'
    }]
    if haEnabled:
        resources.append({
            'name': 'load_balancer',
            'type': 'load_balancer.py',
            'properties': {
                'region': context.properties['region'],
                'num_instances': context.properties['num_instances'],
                'vm_zones': context.properties['vm_zones'],
                'named_ports': context.properties['named_ports'],
                'service_port': context.properties['service_port'],
                'allow_global_access': context.properties['allow_global_access'],
                'inside_network': context.properties['inside_network'],
                'use_internal_lb': context.properties['use_internal_lb']
                # 'instance_urls': '$(ref.vm.instance_urls)'
            },
            'metadata': {
                'dependsOn': ['vm']
            }
        })
        outputs.append({
            'name': 'external_lb_ip',
            'value': '$(ref.load_balancer.external_lb_ip)'
        })
        if context.properties['use_internal_lb']:
            outputs.append({
                'name': 'internal_lb_ip',
                'value': '$(ref.load_balancer.internal_lb_ip)'
            })
    return {'resources': resources, 'outputs': outputs}