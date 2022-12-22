# getDevice

The getDevice operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the device record associated with the specified ID. Registers or unregisters a device. If no ID is specified for a GET, retrieves list of all device records.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for a device. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getDevice' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDevice"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```