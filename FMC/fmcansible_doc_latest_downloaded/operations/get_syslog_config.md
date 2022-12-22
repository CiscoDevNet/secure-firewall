# getSyslogConfig

The getSyslogConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/syslogalerts/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/syslogalerts/{object_id}.md) path.&nbsp;
## Description
**Retrieves the syslog alert object associated with the specified ID. If no ID is specified, retrieves list of all syslog alert objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a syslog alert. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSyslogConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSyslogConfig"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```