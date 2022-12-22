# createVpnEndpoint

The createVpnEndpoint operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns/{containerUUID}/endpoints](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns/{container_uuid}/endpoints.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies a specific Endpoint associated with the specified ID inside a VPN Site To Site Topology. If no ID is specifid for a GET, retrieves list of all Endpoints of a topology. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| peerType | PEER |
| device | {'name': '192.168.0.32', 'id': '933e077a-64cc-11e8-9be7-da0d15a02570', 'type': 'Device'} |
| interface | {'name': 'inside', 'id': '005056A9-9F80-0ed3-0000-008589934781', 'type': 'PhysicalInterface'} |
| protectedNetworks | {'networks': [{'name': 'IPv4-Private-10.0.0.0-8', 'id': '95916354-5aa1-4057-8eea-b42a5a207abc', 'type': 'Network'}]} |
| connectionType | BIDIRECTIONAL |
| isLocalTunnelIdEnabled | True |
| localIdentityType | EMAIL |
| localIdentityString | bgl-asa-umb-sg@1234-5204-umbrella.com |
| type | EndPoint |
| vpnFilterAcl | {'name': 'ACL-Ext-1', 'id': '00505681-0FCA-0ed3-0000-008589934599', 'type': 'ExtendedAccessList'} |
| overrideRemoteVpnFilter | False |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createVpnEndpoint' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createVpnEndpoint"
    data:
        peerType: "PEER"
        device: {'name': '192.168.0.32', 'id': '933e077a-64cc-11e8-9be7-da0d15a02570', 'type': 'Device'}
        interface: {'name': 'inside', 'id': '005056A9-9F80-0ed3-0000-008589934781', 'type': 'PhysicalInterface'}
        protectedNetworks: {'networks': [{'name': 'IPv4-Private-10.0.0.0-8', 'id': '95916354-5aa1-4057-8eea-b42a5a207abc', 'type': 'Network'}]}
        connectionType: "BIDIRECTIONAL"
        isLocalTunnelIdEnabled: True
        localIdentityType: "EMAIL"
        localIdentityString: "bgl-asa-umb-sg@1234-5204-umbrella.com"
        type: "EndPoint"
        vpnFilterAcl: {'name': 'ACL-Ext-1', 'id': '00505681-0FCA-0ed3-0000-008589934599', 'type': 'ExtendedAccessList'}
        overrideRemoteVpnFilter: False
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```