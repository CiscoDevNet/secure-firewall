# updateDevice

The updateDevice operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the device record associated with the specified ID. Registers or unregisters a device. If no ID is specified for a GET, retrieves list of all device records. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | device_uuid |
| name | nachos_updated |
| type | Device |
| hostName | 10.20.30.40 |
| prohibitPacketTransfer | True |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for a device. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateDevice' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateDevice"
    data:
        id: "device_uuid"
        name: "nachos_updated"
        type: "Device"
        hostName: "10.20.30.40"
        prohibitPacketTransfer: True
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```