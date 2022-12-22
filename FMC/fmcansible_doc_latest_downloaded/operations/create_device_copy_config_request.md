# createDeviceCopyConfigRequest

The createDeviceCopyConfigRequest operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/copyconfigrequests](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/copyconfigrequests.md) path.&nbsp;
## Description
**Copy configuration operation on device. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| sourceDevice | {'id': 'device_uuid', 'type': 'Device'} |
| targetDeviceList | [{'id': 'device_uuid', 'type': 'Device'}] |
| copySharedPolicies | False |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createDeviceCopyConfigRequest' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createDeviceCopyConfigRequest"
    data:
        sourceDevice: {'id': 'device_uuid', 'type': 'Device'}
        targetDeviceList: [{'id': 'device_uuid', 'type': 'Device'}]
        copySharedPolicies: False
    path_params:
        domainUUID: "{{ domain_uuid }}"

```