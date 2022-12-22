# deleteTimeRange

The deleteTimeRange operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/timeranges/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/timeranges/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates and modifies the TimeRange object. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a TimeRange object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteTimeRange' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteTimeRange"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```