# getApplicationCategory

The getApplicationCategory operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/applicationcategories/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/applicationcategories/{object_id}.md) path.&nbsp;
## Description
**Retrieves the application category object associated with the specified ID. If no ID is specified, retrieves list of all application category objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getApplicationCategory' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getApplicationCategory"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```