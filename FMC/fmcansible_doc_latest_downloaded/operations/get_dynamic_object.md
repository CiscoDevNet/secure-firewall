# getDynamicObject

The getDynamicObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dynamicobjects/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dynamicobjects/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Dynamic Object associated with the specified ID. If no ID is specified for a GET, retrieves list of all Dynamic Objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier or name of Dynamic Object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| includeCount | False | string <td colspan=3> If parameter is specified, mappingsCount field will be added into metadata. Can be used if object ID is specified in path. |

## Example
```yaml
- name: Execute 'getDynamicObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDynamicObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        includeCount: "{{ include_count }}"

```