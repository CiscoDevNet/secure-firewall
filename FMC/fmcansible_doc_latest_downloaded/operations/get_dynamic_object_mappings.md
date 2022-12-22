# getDynamicObjectMappings

The getDynamicObjectMappings operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dynamicobjects/{objectId}/mappings](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dynamicobjects/{object_id}/mappings.md) path.&nbsp;
## Description
**Retrieves, adds, or removes the Dynamic Object Mappings associated with the specified ID.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier or name of Dynamic Object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getDynamicObjectMappings' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDynamicObjectMappings"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```