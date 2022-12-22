# deleteLocalRealmUser

The deleteLocalRealmUser operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/localrealmusers/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/localrealmusers/{object_id}.md) path.&nbsp;
## Description
**Retrieves the local realm user object associated with the specified ID. If no ID is specified, retrieves list of all local realm user objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of local realm user. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteLocalRealmUser' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteLocalRealmUser"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```