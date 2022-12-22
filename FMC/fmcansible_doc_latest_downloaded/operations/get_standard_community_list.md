# getStandardCommunityList

The getStandardCommunityList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/standardcommunitylists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/standardcommunitylists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the StandardCommunityList object associated with the specified ID. If no ID is specified for a GET, retrieves list of all StandardCommunityList objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique Identifier of the Standard community list object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getStandardCommunityList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getStandardCommunityList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```