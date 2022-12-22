# deleteStandardACL

The deleteStandardACL operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/standardaccesslists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/standardaccesslists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Standard Access List associated with the specified ID. If no ID is specified, retrieves list of all Standard Access List. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a Standard Access List object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteStandardACL' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteStandardACL"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```