# updateFTDBridgeGroupInterface

The updateFTDBridgeGroupInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/bridgegroupinterfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/bridgegroupinterfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves the bridge group interface associated with the specified NGFW device ID and interface ID. If no interface ID is specified, retrieves list of all bridge group interfaces associated with the specified NGFW device ID. <div class="alert alert-warning">More details on netmod events(out of sync interfaces):<b> GET /interfaceevents</b></div> _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | bridgeGroupIntfUUID |
| type | BridgeGroupInterface |
| selectedInterfaces | [{'type': 'PhysicalInterface', 'name': 'GigabitEthernet0/0', 'id': 'interface UUID'}] |
| enabled | True |
| MTU | 1500 |
| ifname | bridgeGroupIntf1 |
| managementOnly | False |
| ipAddress | 1.2.3.5 |
| bridgeGroupId | 39 |
| ipv4 | {'static': {'address': '1.2.3.5', 'netmask': '25'}} |
| ipv6 | {'addresses': [{'address': '9090::', 'prefix': '12'}], 'dadAttempts': 1, 'nsInterval': 10000, 'reachableTime': 0} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a bridge group interface. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateFTDBridgeGroupInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateFTDBridgeGroupInterface"
    data:
        id: "bridgeGroupIntfUUID"
        type: "BridgeGroupInterface"
        selectedInterfaces: [{'type': 'PhysicalInterface', 'name': 'GigabitEthernet0/0', 'id': 'interface UUID'}]
        enabled: True
        MTU: 1500
        ifname: "bridgeGroupIntf1"
        managementOnly: False
        ipAddress: "1.2.3.5"
        bridgeGroupId: 39
        ipv4: {'static': {'address': '1.2.3.5', 'netmask': '25'}}
        ipv6: {'addresses': [{'address': '9090::', 'prefix': '12'}], 'dadAttempts': 1, 'nsInterval': 10000, 'reachableTime': 0}
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```