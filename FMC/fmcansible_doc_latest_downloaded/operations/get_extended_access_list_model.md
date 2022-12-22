# getExtendedAccessListModel

The getExtendedAccessListModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/extendedaccesslists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/extendedaccesslists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Extended Access List associated with the specified ID. If no ID is specified, retrieves list of all Extended Access List.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique Identifier of a Extended Access List object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getExtendedAccessListModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getExtendedAccessListModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```