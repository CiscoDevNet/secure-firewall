# createFTDHADeviceContainer

The createFTDHADeviceContainer operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devicehapairs/ftddevicehapairs](/paths//api/fmc_config/v1/domain/{domain_uuid}/devicehapairs/ftddevicehapairs.md) path.&nbsp;
## Description
**Retrieves or modifies the FTD HA record associated with the specified ID. Creates or breaks or deletes a FTD HA pair. If no ID is specified for a GET, retrieves list of all FTD HA pairs. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| primary | {'id': 'primary_uuid'} |
| secondary | {'id': 'secondary_uuid'} |
| name | <ha-name> |
| type | DeviceHAPair |
| ftdHABootstrap | {'isEncryptionEnabled': 'false', 'encKeyGenerationScheme': 'CUSTOM', 'sharedKey': 'cisco123', 'useSameLinkForFailovers': 'true', 'lanFailover': {'useIPv6Address': 'false', 'subnetMask': '255.255.255.0', 'interfaceObject': {'id': '<uuid>', 'type': 'PhysicalInterface', 'name': 'GigabitEthernet0/0'}, 'standbyIP': '1.1.1.2', 'logicalName': 'LAN-INTERFACE', 'activeIP': '1.1.1.1'}, 'statefulFailover': {'useIPv6Address': 'true', 'subnetMask': '255.255.255.0', 'interfaceObject': {'id': '<uuid>', 'type': 'PhysicalInterface', 'name': 'GigabitEthernet0/0'}, 'standbyIP': '1.1.1.2', 'logicalName': 'STATEFUL-INTERFACE', 'activeIP': '1.1.1.1'}} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createFTDHADeviceContainer' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createFTDHADeviceContainer"
    data:
        primary: {'id': 'primary_uuid'}
        secondary: {'id': 'secondary_uuid'}
        name: "<ha-name>"
        type: "DeviceHAPair"
        ftdHABootstrap: {'isEncryptionEnabled': 'false', 'encKeyGenerationScheme': 'CUSTOM', 'sharedKey': 'cisco123', 'useSameLinkForFailovers': 'true', 'lanFailover': {'useIPv6Address': 'false', 'subnetMask': '255.255.255.0', 'interfaceObject': {'id': '<uuid>', 'type': 'PhysicalInterface', 'name': 'GigabitEthernet0/0'}, 'standbyIP': '1.1.1.2', 'logicalName': 'LAN-INTERFACE', 'activeIP': '1.1.1.1'}, 'statefulFailover': {'useIPv6Address': 'true', 'subnetMask': '255.255.255.0', 'interfaceObject': {'id': '<uuid>', 'type': 'PhysicalInterface', 'name': 'GigabitEthernet0/0'}, 'standbyIP': '1.1.1.2', 'logicalName': 'STATEFUL-INTERFACE', 'activeIP': '1.1.1.1'}}
    path_params:
        domainUUID: "{{ domain_uuid }}"

```