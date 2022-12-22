# updateAsPathList

The updateAsPathList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/aspathlists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/aspathlists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the AsPath List associated with the specified ID. If no ID is specified, retrieves list of all AsPath Lists. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | aspathlistObjectUUID |
| entries | [{'sequence': 1, 'action': 'PERMIT', 'regularExpression': '100/15+10*200'}] |
| name | 300 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a AsPath List object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateAsPathList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateAsPathList"
    data:
        id: "aspathlistObjectUUID"
        entries: [{'sequence': 1, 'action': 'PERMIT', 'regularExpression': '100/15+10*200'}]
        name: 300
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```