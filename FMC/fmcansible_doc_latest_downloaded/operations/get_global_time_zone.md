# getGlobalTimeZone

The getGlobalTimeZone operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/globaltimezones/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/globaltimezones/{object_id}.md) path.&nbsp;
## Description
**Retrieves the objects representing all the time zones defined in the IANA global time zone (tz) database.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the global time zone as per the IANA tz database. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getGlobalTimeZone' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getGlobalTimeZone"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```