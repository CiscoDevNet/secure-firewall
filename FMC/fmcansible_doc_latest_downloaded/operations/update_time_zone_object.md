# updateTimeZoneObject

The updateTimeZoneObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/timezoneobjects/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/timezoneobjects/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates and modifies the Time Zone Object. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| timeZoneId | Asia/Calcutta |
| type | TimeZoneObject |
| description | edited |
| name | TestPUTObject |
| id | timeZoneObjectId |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Time Zone object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateTimeZoneObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateTimeZoneObject"
    data:
        timeZoneId: "Asia/Calcutta"
        type: "TimeZoneObject"
        description: "edited"
        name: "TestPUTObject"
        id: "timeZoneObjectId"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```