from helpers import common

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

    # networking
    # existing network
    if 'subnet' in context.properties:
        # example: https://www.googleapis.com/compute/v1/projects/cisco-asa-terraform/regions/us-west1/subnetworks/vpc-1-subnet-west1
        subnet_url=''.join([common.COMPUTE_URL_BASE, 'projects/',
                                context.env['project'],
                                f'/regions/{context.properties["region"]}/subnetworks/',context.properties['subnet']])
        # example: https://www.googleapis.com/compute/v1/projects/cisco-asa-terraform/global/networks/vpc-1
        network_url=''.join([common.COMPUTE_URL_BASE, 'projects/',
                                context.env['project'],
                                f'/global/networks/{context.properties["network"]}'])
    # new network
    else:
        # Networking provisioning
        networking = {
        'name': 'networking',
        'type': 'networking.py',
        'properties': {
            'region': context.properties['region'],
            'network': context.properties['network'],
            'network_subnet_cidr_range': context.properties['network_subnet_cidr_range'],
            'custom_route_tag': context.properties['custom_route_tag'],
            }
        }
        subnet_url =  f'$(ref.networking.subnet_link)'
        network_url = f'$(ref.networking.network_link)'

    # firewall
    firewall = {
        'name': 'firewall',
        'type': 'firewall.py',
        'properties': {
            'network_url': network_url,
            'service_account': '$(ref.service_accounts.email)',
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

    # Appliance VMs

    vm = {
        'name': 'vm',
        'type': 'vm.py',
        'properties': {
            'vm_zones': context.properties['vm_zones'],
            'num_instances': context.properties['num_instances'],
            'cisco_product_version': context.properties['cisco_product_version'],
            'hostname': context.properties['hostname'],
            'boot_disk_size': context.properties['boot_disk_size'],
            'vm_machine_type': context.properties['vm_machine_type'],
            'vm_instance_labels': context.properties['vm_instance_labels'],
            'vm_instance_tags': context.properties['vm_instance_tags'],
            'admin_ssh_pub_key': context.properties['admin_ssh_pub_key'],
            'admin_password': context.properties['admin_password'],
            'day_0_config': context.properties['day_0_config'],
            'service_account': f'$(ref.service_accounts.email)',
            'appliance_ips': context.properties['appliance_ips'],
            'subnet_url': subnet_url,         
        },
        'metadata': {
            'dependsOn': ['networking']
        }
    }
    #Prepare all resources to be provisioned
    # existing network
    if 'subnet' in context.properties:
        resources += [services, sa, firewall, vm]
    # new network
    else:
        resources += [services, sa, networking, firewall, vm]
    outputs = [
    {
        'name': 'vm_urls',
        'value': f'$(ref.vm.instance_urls)'
    }, 
     {
        'name': 'vm_ips',
        'value': f'$(ref.vm.instance_ips)'
     }
    ]
    return {'resources': resources, 'outputs': outputs}