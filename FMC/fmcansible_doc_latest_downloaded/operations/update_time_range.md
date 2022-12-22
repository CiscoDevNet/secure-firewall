# updateTimeRange

The updateTimeRange operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/timeranges/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/timeranges/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates and modifies the TimeRange object. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| effectiveEndDateTime | 16/08/2018T08:00 |
| name | test_updated |
| type | TimeRange |
| id | 0050568A-906F-0ed3-0000-343597383765 |
| overridable | False |
| description | sample description |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a TimeRange object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateTimeRange' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateTimeRange"
    data:
        effectiveEndDateTime: "16/08/2018T08:00"
        name: "test_updated"
        type: "TimeRange"
        id: "0050568A-906F-0ed3-0000-343597383765"
        overridable: False
        description: "sample description"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```