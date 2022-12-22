# getCommunityList

The getCommunityList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/communitylists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/communitylists/{object_id}.md) path.&nbsp;
## Description
**Community lists object Read only.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> UUID of the community lists object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getCommunityList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getCommunityList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```