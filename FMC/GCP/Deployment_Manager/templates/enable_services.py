##################################
# Enables GCP Services
##################################
def GenerateConfig(context):
    resources = []
    for service in context.properties['services']:
        resources.append(
            {
                'name': f'{service}-enabled',
                'type': 'deploymentmanager.v2.virtual.enableService',
                'properties': {
                    'consumerId': f"project:{context.env['project']}",
                    'serviceName': service
                }
            }
        )
    return {'resources': resources}