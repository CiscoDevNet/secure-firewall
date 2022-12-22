# createMultipleTimeZoneObject

The createMultipleTimeZoneObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/timezoneobjects](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/timezoneobjects.md) path.&nbsp;
## Description
**Retrieves, deletes, creates and modifies the Time Zone Object. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| timeZoneId | Asia/Calcutta |
| dstDayRecurrence | {'startMonth': 'JAN', 'startWeek': 'FIRST', 'startDayOfWeek': 'MON', 'startTime': '11:00', 'offset': 20, 'endWeek': 'SECOND', 'endMonth': 'FEB', 'endDayOfWeek': 'TUE', 'endTime': '11:01'} |
| type | TimeZoneObject |
| name | TestPOSTObject |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for Time Zone objects. |

## Example
```yaml
- name: Execute 'createMultipleTimeZoneObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleTimeZoneObject"
    data:
        timeZoneId: "Asia/Calcutta"
        dstDayRecurrence: {'startMonth': 'JAN', 'startWeek': 'FIRST', 'startDayOfWeek': 'MON', 'startTime': '11:00', 'offset': 20, 'endWeek': 'SECOND', 'endMonth': 'FEB', 'endDayOfWeek': 'TUE', 'endTime': '11:01'}
        type: "TimeZoneObject"
        name: "TestPOSTObject"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```