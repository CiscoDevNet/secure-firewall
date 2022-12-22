# deleteRealm

The deleteRealm operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/realms/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/realms/{object_id}.md) path.&nbsp;
## Description
**Retrieves the realm object associated with the specified ID. If no ID is specified, retrieves list of all realm objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of user realm. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteRealm' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteRealm"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```