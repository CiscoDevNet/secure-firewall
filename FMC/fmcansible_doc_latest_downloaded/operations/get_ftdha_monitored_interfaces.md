# getFTDHAMonitoredInterfaces

The getFTDHAMonitoredInterfaces operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devicehapairs/ftddevicehapairs/{containerUUID}/monitoredinterfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devicehapairs/ftddevicehapairs/{container_uuid}/monitoredinterfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the FTD HA Monitored interface policy record associated with the specified FTD HA pair. If no ID is specified for a GET, retrieves list of all FTD HA monitored interface policy records.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of a FTD HA Monitored interface policy. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getFTDHAMonitoredInterfaces' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getFTDHAMonitoredInterfaces"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```