# updateVirtualSwitch

The updateVirtualSwitch operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/virtualswitches/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/virtualswitches/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the virtual switch associated with the specified NGIPS device ID and virtual switch ID. If no virtual switch ID is specified, retrieves list of all virtual switches associated with the specified NGIPS device ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | virtual_switch_2 |
| id | virtualswitchUUID2 |
| type | VirtualSwitch |
| domainId | 3 |
| dropBPDU | True |
| enableSpanningTreeProtocol | False |
| strictTCPEnforcement | False |
| hybridInterface | {'name': 'hybrid_1', 'type': 'FPLogicalInterface', 'id': 'hybridInterfaceUUID'} |
| switchedInterfaces | [{'name': 's1p3.1', 'type': 'FPLogicalInterface', 'id': 'switchedInterfaceUUID1'}, {'name': 's1p4.1', 'type': 'FPLogicalInterface', 'id': 'switchedInterfaceUUID2'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a virtual switch. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateVirtualSwitch' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateVirtualSwitch"
    data:
        name: "virtual_switch_2"
        id: "virtualswitchUUID2"
        type: "VirtualSwitch"
        domainId: 3
        dropBPDU: True
        enableSpanningTreeProtocol: False
        strictTCPEnforcement: False
        hybridInterface: {'name': 'hybrid_1', 'type': 'FPLogicalInterface', 'id': 'hybridInterfaceUUID'}
        switchedInterfaces: [{'name': 's1p3.1', 'type': 'FPLogicalInterface', 'id': 'switchedInterfaceUUID1'}, {'name': 's1p4.1', 'type': 'FPLogicalInterface', 'id': 'switchedInterfaceUUID2'}]
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```