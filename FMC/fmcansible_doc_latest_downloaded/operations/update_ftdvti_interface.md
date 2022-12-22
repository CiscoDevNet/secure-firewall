# updateFTDVTIInterface

The updateFTDVTIInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/virtualtunnelinterfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/virtualtunnelinterfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the vti interface associated with the specified NGFW device ID and/or interface ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | VTIInterface |
| name | Tunnel5 |
| tunnelSource | {'name': 'GigabitEthernet0/0', 'type': 'PhysicalInterface', 'id': 'interface UUID'} |
| tunnelId | 5 |
| enabled | True |
| ifname | tunnel-5 |
| securityZone | {'id': '<security-zone-uuid>', 'type': 'SecurityZone', 'links': {'self': 'http://.....'}} |
| ipv4 | {'static': {'address': '2.2.2.2', 'netmask': '255.255.255.0'}} |
| ipsecMode | ipv4 |
| id | 00000000-0000-0ed3-0000-206158430258 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a NGFW vti interface. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateFTDVTIInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateFTDVTIInterface"
    data:
        type: "VTIInterface"
        name: "Tunnel5"
        tunnelSource: {'name': 'GigabitEthernet0/0', 'type': 'PhysicalInterface', 'id': 'interface UUID'}
        tunnelId: 5
        enabled: True
        ifname: "tunnel-5"
        securityZone: {'id': '<security-zone-uuid>', 'type': 'SecurityZone', 'links': {'self': 'http://.....'}}
        ipv4: {'static': {'address': '2.2.2.2', 'netmask': '255.255.255.0'}}
        ipsecMode: "ipv4"
        id: "00000000-0000-0ed3-0000-206158430258"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```