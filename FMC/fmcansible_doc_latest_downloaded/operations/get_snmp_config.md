# getSNMPConfig

The getSNMPConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/snmpalerts/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/snmpalerts/{object_id}.md) path.&nbsp;
## Description
**Retrieves the SNMP alert object associated with the specified ID. If no ID is specified, retrieves list of all SNMP alert objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a SNMP alert. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSNMPConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSNMPConfig"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```