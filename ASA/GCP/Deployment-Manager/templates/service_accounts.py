##################################
# Provisions Service Account
##################################
def GenerateConfig(context):
    resources = [
        {
            'name': context.properties['account_id'],
            'type': 'iam.v1.serviceAccount',
            'properties': {
                'accountId': context.properties['account_id'].lower(),
                'displayName': context.properties['display_name']
                # 'description': context.properties['description']
            }
        }
    ]

    outputs = [
        {
            'name': 'email',
            'value': f"$(ref.{context.properties['account_id']}.email)",
        }
    ]
    return {'resources': resources, 'outputs': outputs}