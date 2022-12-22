# getTimeZoneObject

The getTimeZoneObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/timezoneobjects/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/timezoneobjects/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates and modifies the Time Zone Object.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Time Zone object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the object on given target ID. |

## Example
```yaml
- name: Execute 'getTimeZoneObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getTimeZoneObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```