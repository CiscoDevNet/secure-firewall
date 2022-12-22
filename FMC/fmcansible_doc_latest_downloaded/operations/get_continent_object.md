# getContinentObject

The getContinentObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/continents/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/continents/{object_id}.md) path.&nbsp;
## Description
**Retrieves the continent object associated with the specified ID. If no ID is specified, retrieves list of all continent objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of continent objects. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getContinentObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getContinentObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```