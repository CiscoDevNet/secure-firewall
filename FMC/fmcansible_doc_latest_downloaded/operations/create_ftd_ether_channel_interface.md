# createFTDEtherChannelInterface

The createFTDEtherChannelInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/etherchannelinterfaces](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/etherchannelinterfaces.md) path.&nbsp;
## Description
**Retrieves the ethernet channel interface associated with the specified NGFW device ID and interface ID. If no ID is specified, retrieves list of all ethernet channel interfaces associated with the specified NGFW device ID. <div class="alert alert-warning">More details on netmod events(out of sync interfaces):<b> GET /interfaceevents</b></div> _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | EtherChannelInterface |
| mode | NONE |
| lacpMode | ACTIVE |
| lacpRate | DEFAULT |
| maxActivePhysicalInterface | 8 |
| minActivePhysicalInterface | 1 |
| selectedInterfaces | [{'type': 'PhysicalInterface', 'name': 'GigabitEthernet0/0', 'id': 'interface UUID'}] |
| hardware | {'duplex': 'FULL', 'speed': 'THOUSAND', 'autoNegState': True} |
| LLDP | {'transmit': False, 'receive': False} |
| loadBalancing | SRC_IP_PORT |
| etherChannelId | 1 |
| enabled | True |
| MTU | 1500 |
| priority | 10 |
| managementOnly | False |
| securityZone | {'id': 'securityZoneUUID', 'type': 'SecurityZone'} |
| ifname | NewEthChannel |
| enableAntiSpoofing | False |
| enableSGTPropagate | True |
| overrideDefaultFragmentSetting | {} |
| ipv4 | {'static': {'address': '1.2.3.5', 'netmask': '25'}} |
| ipv6 | {'addresses': [{'address': '9090::', 'prefix': '12'}], 'dadAttempts': 1, 'nsInterval': 10000, 'reachableTime': 0} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createFTDEtherChannelInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createFTDEtherChannelInterface"
    data:
        type: "EtherChannelInterface"
        mode: "NONE"
        lacpMode: "ACTIVE"
        lacpRate: "DEFAULT"
        maxActivePhysicalInterface: 8
        minActivePhysicalInterface: 1
        selectedInterfaces: [{'type': 'PhysicalInterface', 'name': 'GigabitEthernet0/0', 'id': 'interface UUID'}]
        hardware: {'duplex': 'FULL', 'speed': 'THOUSAND', 'autoNegState': True}
        LLDP: {'transmit': False, 'receive': False}
        loadBalancing: "SRC_IP_PORT"
        etherChannelId: 1
        enabled: True
        MTU: 1500
        priority: 10
        managementOnly: False
        securityZone: {'id': 'securityZoneUUID', 'type': 'SecurityZone'}
        ifname: "NewEthChannel"
        enableAntiSpoofing: False
        enableSGTPropagate: True
        overrideDefaultFragmentSetting: {}
        ipv4: {'static': {'address': '1.2.3.5', 'netmask': '25'}}
        ipv6: {'addresses': [{'address': '9090::', 'prefix': '12'}], 'dadAttempts': 1, 'nsInterval': 10000, 'reachableTime': 0}
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```