# getApplicationTag

The getApplicationTag operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/applicationtags/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/applicationtags/{object_id}.md) path.&nbsp;
## Description
**Retrieves the application tag object associated with the specified ID. If no ID is specified, retrieves list of all application tag objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getApplicationTag' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getApplicationTag"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```