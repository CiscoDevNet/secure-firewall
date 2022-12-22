# getFTDEtherChannelInterface

The getFTDEtherChannelInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/etherchannelinterfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/etherchannelinterfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves the ethernet channel interface associated with the specified NGFW device ID and interface ID. If no ID is specified, retrieves list of all ethernet channel interfaces associated with the specified NGFW device ID. <div class="alert alert-warning">More details on netmod events(out of sync interfaces):<b> GET /interfaceevents</b></div>**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a ethernet channel interface. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getFTDEtherChannelInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getFTDEtherChannelInterface"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```