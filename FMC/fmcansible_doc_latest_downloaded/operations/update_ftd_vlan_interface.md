# updateFTDVlanInterface

The updateFTDVlanInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/vlaninterfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/vlaninterfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves the vlan interface associated with the specified NGFW device ID and interface ID. If no interface ID is specified, retrieves list of all vlan interfaces associated with the specified NGFW device ID. <div class="alert alert-warning">More details on netmod events(out of sync interfaces):<b> GET /interfaceevents</b></div> _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | VlanInterface |
| vlanId | 30 |
| disablePortForwardOnVlan | {'id': 'interface UUID', 'type': 'VlanInterface', 'name': 'Vlan1'} |
| enabled | True |
| enableAntiSpoofing | True |
| ifname | Intf_name |
| name | Vlan30 |
| id | vlaninterfaceUUID |
| mode | NONE |
| MTU | 1500 |
| priority | 10 |
| overrideDefaultFragmentSetting | {'size': 200, 'chain': 24, 'timeout': 5} |
| arpConfig | [{'ipAddress': '101.101.101.101/25', 'macAddress': '03DC.1234.2323', 'enableAlias': False}] |
| securityZone | {'id': 'sec_zone_id', 'type': 'SecurityZone'} |
| ipv4 | {'static': {'address': '1.2.3.4', 'netmask': '25'}, 'dhcp': {'enableDefaultRouteDHCP': 'true', 'dhcpRouteMetric': 1}, 'pppoe': {'vpdnGroupName': 'VPDN_group_name', 'pppoeUser': 'User_name', 'pppoePassword': 'User_password', 'pppAuth': '< PAP | CHAP | MSCHAP>', 'pppoeRouteMetric': 1, 'enableRouteSettings': True, 'ipAddress': '1.2.3.4/25', 'storeCredsInFlash': False}} |
| ipv6 | {'enableIPV6': True, 'enforceEUI64': False, 'linkLocalAddress': 'FE80::', 'enableAutoConfig': True, 'enableDHCPAddrConfig': True, 'enableDHCPNonAddrConfig': False, 'dadAttempts': 1, 'nsInterval': 10000, 'reachableTime': 0, 'enableRA': False, 'raLifeTime': 1800, 'raInterval': 200, 'addresses': [{'address': '2001::', 'prefix': '124', 'enforceEUI64': False}, {'address': '8080::', 'prefix': '12', 'enforceEUI64': True}], 'prefixes': [{'address': '2001::/124', 'default': False, 'advertisement': {'offlink': False, 'autoConfig': False, 'preferLifeTime': {'duration': {'preferLifeTime': 604800, 'validLifeTime': 2592300}, 'expirationLifeTime': {'preferDateTime': '2016-11-05T08:15:30.000Z', 'validDateTime': '2016-12-05T08:15:30.000Z'}}}}]} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a NGFW vlan interface. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateFTDVlanInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateFTDVlanInterface"
    data:
        type: "VlanInterface"
        vlanId: 30
        disablePortForwardOnVlan: {'id': 'interface UUID', 'type': 'VlanInterface', 'name': 'Vlan1'}
        enabled: True
        enableAntiSpoofing: True
        ifname: "Intf_name"
        name: "Vlan30"
        id: "vlaninterfaceUUID"
        mode: "NONE"
        MTU: 1500
        priority: 10
        overrideDefaultFragmentSetting: {'size': 200, 'chain': 24, 'timeout': 5}
        arpConfig: [{'ipAddress': '101.101.101.101/25', 'macAddress': '03DC.1234.2323', 'enableAlias': False}]
        securityZone: {'id': 'sec_zone_id', 'type': 'SecurityZone'}
        ipv4: {'static': {'address': '1.2.3.4', 'netmask': '25'}, 'dhcp': {'enableDefaultRouteDHCP': 'true', 'dhcpRouteMetric': 1}, 'pppoe': {'vpdnGroupName': 'VPDN_group_name', 'pppoeUser': 'User_name', 'pppoePassword': 'User_password', 'pppAuth': '< PAP | CHAP | MSCHAP>', 'pppoeRouteMetric': 1, 'enableRouteSettings': True, 'ipAddress': '1.2.3.4/25', 'storeCredsInFlash': False}}
        ipv6: {'enableIPV6': True, 'enforceEUI64': False, 'linkLocalAddress': 'FE80::', 'enableAutoConfig': True, 'enableDHCPAddrConfig': True, 'enableDHCPNonAddrConfig': False, 'dadAttempts': 1, 'nsInterval': 10000, 'reachableTime': 0, 'enableRA': False, 'raLifeTime': 1800, 'raInterval': 200, 'addresses': [{'address': '2001::', 'prefix': '124', 'enforceEUI64': False}, {'address': '8080::', 'prefix': '12', 'enforceEUI64': True}], 'prefixes': [{'address': '2001::/124', 'default': False, 'advertisement': {'offlink': False, 'autoConfig': False, 'preferLifeTime': {'duration': {'preferLifeTime': 604800, 'validLifeTime': 2592300}, 'expirationLifeTime': {'preferDateTime': '2016-11-05T08:15:30.000Z', 'validDateTime': '2016-12-05T08:15:30.000Z'}}}}]}
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```