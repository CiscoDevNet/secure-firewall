# getTimeRange

The getTimeRange operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/timeranges/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/timeranges/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates and modifies the TimeRange object.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a TimeRange object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getTimeRange' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getTimeRange"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```