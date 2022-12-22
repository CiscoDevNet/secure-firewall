# getExpandedCommunityList

The getExpandedCommunityList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/expandedcommunitylists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/expandedcommunitylists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the ExpandedCommunityList object associated with the specified ID. If no ID is specified for a GET, retrieves list of all ExpandedCommunityList objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique Identifier of the Expanded community list object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getExpandedCommunityList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getExpandedCommunityList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```