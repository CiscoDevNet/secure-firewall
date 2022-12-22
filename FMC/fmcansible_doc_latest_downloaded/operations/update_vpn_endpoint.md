# updateVpnEndpoint

The updateVpnEndpoint operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns/{containerUUID}/endpoints/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns/{container_uuid}/endpoints/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies a specific Endpoint associated with the specified ID inside a VPN Site To Site Topology. If no ID is specifid for a GET, retrieves list of all Endpoints of a topology. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | 005056A9-6FFE-0ed3-0000-120259084433 |
| type | EndPoint |
| extranet | False |
| device | {'name': '192.168.0.22', 'id': '463b5424-2812-11e8-9a5f-89adee70d40d', 'type': 'Device'} |
| interface | {'name': 's1', 'id': '005056A9-6FFE-0ed3-0000-042949673272'} |
| connectionType | BIDIRECTIONAL |
| isLocalTunnelIdEnabled | True |
| localIdentityType | EMAIL |
| localIdentityString | bgl-asa-umb-sg@1234-5204-umbrella.com |
| protectedNetworks | {'networks': [{'name': 'IPv4-Private-172.16.0.0-12', 'id': 'b7a78a7d-20c5-47b2-b02f-86b4360112ac'}]} |
| peerType | PEER |
| vpnFilterAcl | {'name': 'ACL-Ext-1', 'id': '00505681-0FCA-0ed3-0000-008589934599', 'type': 'ExtendedAccessList'} |
| overrideRemoteVpnFilter | False |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for an Endpoint in a Site to Site VPN topology. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateVpnEndpoint' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateVpnEndpoint"
    data:
        id: "005056A9-6FFE-0ed3-0000-120259084433"
        type: "EndPoint"
        extranet: False
        device: {'name': '192.168.0.22', 'id': '463b5424-2812-11e8-9a5f-89adee70d40d', 'type': 'Device'}
        interface: {'name': 's1', 'id': '005056A9-6FFE-0ed3-0000-042949673272'}
        connectionType: "BIDIRECTIONAL"
        isLocalTunnelIdEnabled: True
        localIdentityType: "EMAIL"
        localIdentityString: "bgl-asa-umb-sg@1234-5204-umbrella.com"
        protectedNetworks: {'networks': [{'name': 'IPv4-Private-172.16.0.0-12', 'id': 'b7a78a7d-20c5-47b2-b02f-86b4360112ac'}]}
        peerType: "PEER"
        vpnFilterAcl: {'name': 'ACL-Ext-1', 'id': '00505681-0FCA-0ed3-0000-008589934599', 'type': 'ExtendedAccessList'}
        overrideRemoteVpnFilter: False
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```