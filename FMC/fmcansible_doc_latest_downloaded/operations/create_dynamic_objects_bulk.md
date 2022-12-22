# createDynamicObjectsBulk

The createDynamicObjectsBulk operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/bulkdynamicobjects](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/bulkdynamicobjects.md) path.&nbsp;
## Description
**Adds or removes Dynamic Object Mappings for specific Dynamic Objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| add | [{'name': 'Marketing', 'description': 'IPs of marketing department', 'type': 'DynamicObject', 'objectType': 'IP'}, {'name': 'Sales', 'description': 'IPs of sales department', 'type': 'DynamicObject', 'objectType': 'IP'}] |
| remove | {'ids': ['550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655441234'], 'names': ['Research'], 'agentIds': ['agent007']} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| propagate | False | string <td colspan=3> Control propagating dynamic object mappings. It can be ["true", "false"]. Default value is "true". |

## Example
```yaml
- name: Execute 'createDynamicObjectsBulk' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createDynamicObjectsBulk"
    data:
        add: [{'name': 'Marketing', 'description': 'IPs of marketing department', 'type': 'DynamicObject', 'objectType': 'IP'}, {'name': 'Sales', 'description': 'IPs of sales department', 'type': 'DynamicObject', 'objectType': 'IP'}]
        remove: {'ids': ['550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655441234'], 'names': ['Research'], 'agentIds': ['agent007']}
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        propagate: "{{ propagate }}"

```