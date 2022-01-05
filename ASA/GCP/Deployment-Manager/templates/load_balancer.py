######################################
# Provisions Load Balancing Resources
######################################
from helpers import common

def getHealthCheck(name, region):
    return {
        'name': name,
        'type': common.REGION_HEALTH_CHECKS_TYPE,
        'properties': {
            'description': 'Deployment Manager Managed.',
            'type': 'TCP',
            'checkIntervalSec': 1,
            'timeoutSec': 1,
            'healthyThreshold': 4,
            'unhealthyThreshold': 5,
            'region': region,
            'tcpHealthCheck': {
                'port': 22
            }
        }
    }

def getExtRegionBackendService(instanceGroups, healthCheckName, region):
    backend_service = {
        'name': 'asa-region-be-ext',
        'type': common.REGION_BACKEND_SERVICES_TYPE,
        'properties': {
            'description': 'Deployment Manager managed external backend service for ASA.',
            'region': region,
            'loadBalancingScheme': 'EXTERNAL',
            'protocol': 'TCP',
            'timeoutSec': 10,
            'healthChecks': [
                f"$(ref.{healthCheckName}.selfLink)"
            ],
            'portName': 'http',
            'backends': [
                {
                    'balancingMode': 'CONNECTION',
                    'description': 'Deployment Manager managed instance group for ASA.',
                    'group': f"$(ref.{ig['name']}.selfLink)"
                }
                for ig in instanceGroups
            ]
        }
    }
    return backend_service

def getIntRegionBackendService(instanceGroups, healthCheckName, region, internalNetwork):
    backend_service = {
        'name': 'asa-region-be-int',
        'type': common.REGION_BACKEND_SERVICES_TYPE,
        'properties': {
            'description': 'Deployment Manager managed internal backend service for ASA.',
            'region': region,
            'loadBalancingScheme': 'INTERNAL',
            'protocol': 'TCP',
            'network': f'$(ref.{internalNetwork}.selfLink)',
            'healthChecks': [
                f"$(ref.{healthCheckName}.selfLink)"
            ],
            'backends': [
                {
                    'balancingMode': 'CONNECTION',
                    'description': 'Deployment Manager managed instance group for ASA.',
                    'group': f"$(ref.{ig['name']}.selfLink)"
                }
                for ig in instanceGroups
            ]
        }
    }
    return backend_service

def getInstanceGroups(context):
    igs = []
    for i in range(context.properties['num_instances']):
        igs.append({
            'name': common.getInstanceGroupName('uig-asa', i+1),
            'type': common.INSTANCE_GROUP_TYPE,
            'properties': {
                'zone': context.properties['vm_zones'][i],
                'namedPorts': [
                    {
                        'name': named_port['name'],
                        'port': named_port['port']
                    }
                    for named_port in context.properties['named_ports']
                ]
            }
        })
    return igs

def getAddVMsToIG(context, instanceGroups):
    actions = []
    for i in range(context.properties['num_instances']):
        ig = instanceGroups[i]
        zone = context.properties['vm_zones'][i]
        vm_name = common.getInstanceName(common.INSTANCE_PREFIX, i+1)
        project = context.env['project']
        selfLink = f"{common.COMPUTE_URL_BASE}projects/{project}/zones/{zone}/instances/{vm_name}"
        actions.append({
            'name': f"ig-{ig['name']}-members",
            'action': common.ADD_INSTANCES_TYPE,
            'properties': {
                'zone': zone,
                'project': project,
                'instanceGroup': ig['name'],
                'instances': [
                    {
                        'instance': selfLink
                    }
                ]
            },
            'metadata': {
                'dependsOn': [ig['name'], vm_name]
            }
        })
    return actions

def getExtForwardingRule(context, backendService):
    return {
        'name': 'asa-ext-fr',
        'type': common.FORWARDING_RULE_TYPE,
        'properties': {
            'region': context.properties['region'],
            'loadBalancingScheme': 'EXTERNAL',
            'portRange': context.properties['service_port'],
            'backendService': f"$(ref.{backendService['name']}.selfLink)"
        }
    }

def getIntForwardingRule(context, backendService):
    internalNetwork = context.properties['inside_network']
    return {
        'name': 'asa-int-fr',
        'type': common.FORWARDING_RULE_TYPE,
        'properties': {
            'region': context.properties['region'],
            'loadBalancingScheme': 'INTERNAL',
            'network': f'$(ref.{internalNetwork}.selfLink)',
            'subnetwork': f'$(ref.{common.getSubnetName(internalNetwork)}.selfLink)',
            'allowGlobalAccess': context.properties['allow_global_access'],
            'ports': [
                context.properties['service_port']
            ],
            'backendService': f"$(ref.{backendService['name']}.selfLink)"
        }
    }

def GenerateConfig(context):
    region = context.properties['region']
    healthCheckName = common.getHealthCheckName('ssh', region)
    intNetwork = context.properties['inside_network']
    resources = []
    outputs = []
    # Create Unmanaged Instance Groups. One per instance
    igs = getInstanceGroups(context)
    # Add Health Check to be used
    resources.append(getHealthCheck(healthCheckName, region))
    # Add External Regional Backend Service using the created unmanaged instance groups
    extBackendService = getExtRegionBackendService(igs, healthCheckName, region)
    resources.append(extBackendService)
    # Add the Unmanaged Instance Groups
    resources.extend(igs)
    # Add the created intances to their respective unmanaged instance groups
    resources.extend(getAddVMsToIG(context, igs))
    # Add External Forwarding Rule
    extForwardingRule = getExtForwardingRule(context, extBackendService)
    resources.append(extForwardingRule)

    if context.properties['use_internal_lb']:
        # Add Internal Regional Backend Service using the created unmanaged instance groups
        intBackendService = getIntRegionBackendService(igs, healthCheckName, region, intNetwork)
        resources.append(intBackendService)
        # Add Internal Forwarding Rule
        intForwardingRule = getIntForwardingRule(context, intBackendService)
        resources.append(intForwardingRule)
        # Add ILB ip address to outputs
        outputs.append({
            'name': 'internal_lb_ip',
            'value': '$(ref.' + intForwardingRule['name'] + '.IPAddress)'
        })
    
    outputs.append({
        'name': 'external_lb_ip',
        'value': '$(ref.' + extForwardingRule['name'] + '.IPAddress)'
    })

    return {
        'resources': resources,
        'outputs': outputs
    }