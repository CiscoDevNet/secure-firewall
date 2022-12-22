# getApplicationProductivity

The getApplicationProductivity operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/applicationproductivities/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/applicationproductivities/{object_id}.md) path.&nbsp;
## Description
**Retrieves the application productivity object associated with the specified ID. If no ID is specified, retrieves list of all application productivity objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getApplicationProductivity' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getApplicationProductivity"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```