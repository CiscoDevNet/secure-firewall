# createInterfaceEvent

The createInterfaceEvent operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/interfaceevents](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/interfaceevents.md) path.&nbsp;
## Description
**Retrieves list of all netmod events on the device. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| action | SYNC_WITH_DEVICE |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createInterfaceEvent' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createInterfaceEvent"
    data:
        action: "SYNC_WITH_DEVICE"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```