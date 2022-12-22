# getStandardACL

The getStandardACL operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/standardaccesslists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/standardaccesslists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Standard Access List associated with the specified ID. If no ID is specified, retrieves list of all Standard Access List.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a Standard Access List object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getStandardACL' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getStandardACL"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```