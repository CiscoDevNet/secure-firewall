# createMultipleFTDVTIInterface

The createMultipleFTDVTIInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/virtualtunnelinterfaces](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/virtualtunnelinterfaces.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the vti interface associated with the specified NGFW device ID and/or interface ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | VTIInterface |
| tunnelSource | {'name': 'GigabitEthernet0/0', 'type': 'PhysicalInterface', 'id': 'interface UUID'} |
| tunnelId | 5 |
| enabled | True |
| ifname | tunnel-5 |
| securityZone | {'id': '<security-zone-uuid>', 'type': 'SecurityZone', 'links': {'self': 'http://.....'}} |
| ipv4 | {'static': {'address': '169.254.100.1', 'netmask': '255.255.255.252'}} |
| ipsecMode | ipv4 |
| id | 00000000-0000-0ed3-0000-206158430258 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for NGFW vti interfaces. |

## Example
```yaml
- name: Execute 'createMultipleFTDVTIInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleFTDVTIInterface"
    data:
        type: "VTIInterface"
        tunnelSource: {'name': 'GigabitEthernet0/0', 'type': 'PhysicalInterface', 'id': 'interface UUID'}
        tunnelId: 5
        enabled: True
        ifname: "tunnel-5"
        securityZone: {'id': '<security-zone-uuid>', 'type': 'SecurityZone', 'links': {'self': 'http://.....'}}
        ipv4: {'static': {'address': '169.254.100.1', 'netmask': '255.255.255.252'}}
        ipsecMode: "ipv4"
        id: "00000000-0000-0ed3-0000-206158430258"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```