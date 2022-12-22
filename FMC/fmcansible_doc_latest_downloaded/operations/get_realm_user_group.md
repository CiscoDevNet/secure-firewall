# getRealmUserGroup

The getRealmUserGroup operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/realmusergroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/realmusergroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves the realm user group object associated with the specified ID. If no ID is specified, retrieves list of all realm user group objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of user groups. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getRealmUserGroup' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getRealmUserGroup"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```