# updateFTDVNIInterface

The updateFTDVNIInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/vniinterfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/vniinterfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves the VNI interface associated with the specified NGFW device ID and interface ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | VNIInterface |
| vniId | 5 |
| multicastGroupAddress | 224.0.0.24 |
| segmentId | 501 |
| vtepID | 1 |
| enabled | True |
| enableAntiSpoofing | True |
| ifname | Intf_name |
| name | Vni30 |
| id | vniinterfaceUUID |
| enableProxy | False |
| overrideDefaultFragmentSetting | {'size': 200, 'chain': 24, 'timeout': 5} |
| arpConfig | [{'ipAddress': '101.101.101.101/25', 'macAddress': '03DC.1234.2323', 'enableAlias': False}] |
| securityZone | {'id': 'sec_zone_id', 'type': 'SecurityZone'} |
| ipv4 | {'static': {'address': '1.2.3.4', 'netmask': '25'}} |
| ipv6 | {'enableIPV6': True, 'enforceEUI64': False, 'linkLocalAddress': 'FE80::', 'enableAutoConfig': True, 'enableDHCPAddrConfig': True, 'enableDHCPNonAddrConfig': False, 'dadAttempts': 1, 'nsInterval': 10000, 'reachableTime': 0, 'enableRA': False, 'raLifeTime': 1800, 'raInterval': 200, 'addresses': [{'address': '2001::', 'prefix': '124', 'enforceEUI64': False}, {'address': '8080::', 'prefix': '12', 'enforceEUI64': True}], 'prefixes': [{'address': '2001::/124', 'default': False, 'advertisement': {'offlink': False, 'autoConfig': False, 'preferLifeTime': {'duration': {'preferLifeTime': 604800, 'validLifeTime': 2592300}, 'expirationLifeTime': {'preferDateTime': '2016-11-05T08:15:30.000Z', 'validDateTime': '2016-12-05T08:15:30.000Z'}}}}]} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a VNI interface. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateFTDVNIInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateFTDVNIInterface"
    data:
        type: "VNIInterface"
        vniId: 5
        multicastGroupAddress: "224.0.0.24"
        segmentId: 501
        vtepID: 1
        enabled: True
        enableAntiSpoofing: True
        ifname: "Intf_name"
        name: "Vni30"
        id: "vniinterfaceUUID"
        enableProxy: False
        overrideDefaultFragmentSetting: {'size': 200, 'chain': 24, 'timeout': 5}
        arpConfig: [{'ipAddress': '101.101.101.101/25', 'macAddress': '03DC.1234.2323', 'enableAlias': False}]
        securityZone: {'id': 'sec_zone_id', 'type': 'SecurityZone'}
        ipv4: {'static': {'address': '1.2.3.4', 'netmask': '25'}}
        ipv6: {'enableIPV6': True, 'enforceEUI64': False, 'linkLocalAddress': 'FE80::', 'enableAutoConfig': True, 'enableDHCPAddrConfig': True, 'enableDHCPNonAddrConfig': False, 'dadAttempts': 1, 'nsInterval': 10000, 'reachableTime': 0, 'enableRA': False, 'raLifeTime': 1800, 'raInterval': 200, 'addresses': [{'address': '2001::', 'prefix': '124', 'enforceEUI64': False}, {'address': '8080::', 'prefix': '12', 'enforceEUI64': True}], 'prefixes': [{'address': '2001::/124', 'default': False, 'advertisement': {'offlink': False, 'autoConfig': False, 'preferLifeTime': {'duration': {'preferLifeTime': 604800, 'validLifeTime': 2592300}, 'expirationLifeTime': {'preferDateTime': '2016-11-05T08:15:30.000Z', 'validDateTime': '2016-12-05T08:15:30.000Z'}}}}]}
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```