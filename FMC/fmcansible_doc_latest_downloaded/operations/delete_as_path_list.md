# deleteAsPathList

The deleteAsPathList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/aspathlists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/aspathlists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the AsPath List associated with the specified ID. If no ID is specified, retrieves list of all AsPath Lists. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a AsPath List object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteAsPathList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteAsPathList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```