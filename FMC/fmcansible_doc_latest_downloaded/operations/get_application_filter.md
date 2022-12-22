# getApplicationFilter

The getApplicationFilter operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/applicationfilters/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/applicationfilters/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the application filter object associated with the specified ID. If no ID is specified, retrieves list of all application filter objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getApplicationFilter' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getApplicationFilter"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```