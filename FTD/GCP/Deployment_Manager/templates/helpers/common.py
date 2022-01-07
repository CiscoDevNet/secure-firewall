# Constants
import random
import string

INSTANCE_TYPE = 'compute.v1.instance'
ADD_INSTANCES_TYPE = 'gcp-types/compute-v1:compute.instanceGroups.addInstances'
INSTANCE_GROUP_TYPE = 'compute.v1.instanceGroup'
REGION_BACKEND_SERVICES_TYPE = 'compute.v1.regionBackendServices'
REGION_HEALTH_CHECKS_TYPE = 'compute.v1.regionHealthChecks'
TCP_PROTOCOL = 'tcp'
NETWORK_TYPE = 'compute.v1.network'
SUBNETWORK_TYPE = 'compute.v1.subnetwork'
FIREWALL_TYPE = 'compute.v1.firewall'
FORWARDING_RULE_TYPE = 'compute.v1.forwardingRule'
COMPUTE_URL_BASE = 'https://www.googleapis.com/compute/v1/'
AUTH_URL_BASE = 'https://www.googleapis.com/auth/'

def getSubnetName(network_name):
    return f"{network_name}-subnet-01"

def getHealthCheckName(prefix, sufix):
    return f"{prefix}-health-check-{sufix}"

def getInstanceName(prefix, index):
    return f'{prefix}-{index}'

def getInstanceGroupName(prefix, index):
    return f'{prefix}-{index}'


def Ref(name):
  return f'$(ref.{name}.selfLink)'

def RefGroup(name):
  return '$(ref.{name}.instanceGroup)'


def randomString(length=5):
  return ''.join(random.choices(string.ascii_lowercase + string.digits, k=length))

def randomizeName(name):
    return f'{name}-{randomString()}'