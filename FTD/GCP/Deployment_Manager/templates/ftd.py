def GenerateConfig(context):
    resources = []
    # Enabling services
    services = {
        'name': 'enable_services',
        'type': 'enable_services.py',
        'properties': {
            'services': context.properties['services']
        }
    }
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
    # Networking provisioning
    networking = {
        'name': 'networking',
        'type': 'networking.py',
        'properties': {
            'region': context.properties['region'],
            'networks': context.properties['networks'],
            'mgmt_network': context.properties['mgmt_network'],
            'outside_network': context.properties['outside_network'],
            'inside_network': context.properties['inside_network'],
            'dmz_network':  context.properties['dmz_network'],
            'custom_route_tag': context.properties['custom_route_tag'],
            # Using email from service_account's output
            'service_account': '$(ref.service_accounts.email)'
        }
    }
    
    
    # Appliance VMs
    vm = {
        'name': 'vm',
        'type': 'vm.py',
        'properties': {
            'networks': context.properties['networks'],
            'vm_zones': context.properties['vm_zones'],
            'num_instances': context.properties['num_instances'],
            'hostname': context.properties['hostname'],
            'cisco_product_version': context.properties['cisco_product_version'],
            'vm_machine_type': context.properties['vm_machine_type'],
            'vm_instance_labels': context.properties['vm_instance_labels'],
            'vm_instance_tags': context.properties['vm_instance_tags'],
            'admin_ssh_pub_key': context.properties['admin_ssh_pub_key'],
            'admin_password': context.properties['admin_password'],
            'day_0_config': context.properties['day_0_config'],
            'service_account': '$(ref.service_accounts.email)',
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

    return {'resources': resources, 'outputs': outputs}