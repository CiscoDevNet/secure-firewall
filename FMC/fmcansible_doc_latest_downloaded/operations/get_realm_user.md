# getRealmUser

The getRealmUser operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/realmusers/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/realmusers/{object_id}.md) path.&nbsp;
## Description
**Retrieves the realm user object associated with the specified ID. If no ID is specified, retrieves list of all realm user objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of user. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getRealmUser' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getRealmUser"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```