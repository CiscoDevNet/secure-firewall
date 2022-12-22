# updateDynamicObjectMappings

The updateDynamicObjectMappings operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dynamicobjects/{objectId}/mappings](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dynamicobjects/{object_id}/mappings.md) path.&nbsp;
## Description
**Retrieves, adds, or removes the Dynamic Object Mappings associated with the specified ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| mappings | ['1.1.1.2', '1.2.3.4/24'] |
| type | DynamicObjectMappings |
| id | 0050568D-75AB-0ed3-0000-038654707195 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier or name of Dynamic Object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| action | False | string <td colspan=3> Specify action for dynamic object mappings. It can be one of ["add", "remove", "remove_all"]. Default value is "add". |
| propagate | False | string <td colspan=3> Control propagating dynamic object mappings. It can be ["true", "false"]. Default value is "true". |

## Example
```yaml
- name: Execute 'updateDynamicObjectMappings' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateDynamicObjectMappings"
    data:
        mappings: ['1.1.1.2', '1.2.3.4/24']
        type: "DynamicObjectMappings"
        id: "0050568D-75AB-0ed3-0000-038654707195"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        action: "{{ action }}"
        propagate: "{{ propagate }}"

```