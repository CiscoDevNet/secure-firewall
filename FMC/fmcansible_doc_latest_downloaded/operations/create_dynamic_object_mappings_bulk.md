# createDynamicObjectMappingsBulk

The createDynamicObjectMappingsBulk operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dynamicobjectmappings](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dynamicobjectmappings.md) path.&nbsp;
## Description
**Adds or removes Dynamic Object Mappings for specific Dynamic Objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| add | [{'mappings': ['192.168.1.1', '192.168.2.1'], 'dynamicObject': {'name': 'Marketing', 'id': '005056AB-931D-0ed3-0000-004294967373', 'type': 'DynamicObject'}}, {'mappings': ['192.168.100.1', '192.168.200.1'], 'dynamicObject': {'id': '005056AB-931D-0ed3-0000-004294967391', 'name': 'IP', 'type': 'DynamicObject'}}] |
| remove | [{'mappings': ['0.0.0.0'], 'dynamicObject': {'id': '005056AB-931D-0ed3-0000-004294967391', 'name': 'IP', 'type': 'DynamicObject'}}] |

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
- name: Execute 'createDynamicObjectMappingsBulk' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createDynamicObjectMappingsBulk"
    data:
        add: [{'mappings': ['192.168.1.1', '192.168.2.1'], 'dynamicObject': {'name': 'Marketing', 'id': '005056AB-931D-0ed3-0000-004294967373', 'type': 'DynamicObject'}}, {'mappings': ['192.168.100.1', '192.168.200.1'], 'dynamicObject': {'id': '005056AB-931D-0ed3-0000-004294967391', 'name': 'IP', 'type': 'DynamicObject'}}]
        remove: [{'mappings': ['0.0.0.0'], 'dynamicObject': {'id': '005056AB-931D-0ed3-0000-004294967391', 'name': 'IP', 'type': 'DynamicObject'}}]
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        propagate: "{{ propagate }}"

```