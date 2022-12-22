# updateVpnIkeSettings

The updateVpnIkeSettings operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns/{containerUUID}/ikesettings/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns/{container_uuid}/ikesettings/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKE Settings associated with the specified ID inside a VPN Site To Site Topology. If no ID is specified for a GET, retrieves Ike Settings of a topology. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| links | {'self': '<fmc_ip>/api/fmc_config/v1/domain/domainUUID/policy/ftds2svpns/topologyUUID/ikesettings/005056A9-7483-0ed3-0000-012884902862'} |
| id | 005056A9-7483-0ed3-0000-012884902862 |
| type | IkeSettings |
| ikeV2Settings | {'automaticPreSharedKeyLength': 7, 'enforceHexBasedPreSharedKeyOnly': True, 'authenticationType': 'AUTOMATIC_PRE_SHARED_KEY', 'policies': [{'name': 'DES-SHA-SHA', 'id': '005056A9-6FFE-0ed3-0000-000000000402', 'type': 'Ike2'}, {'name': 'AES-SHA-SHA', 'id': '005056A9-6FFE-0ed3-0000-000000000401', 'type': 'Ike2'}]} |
| ikeV1Settings | {'automaticPreSharedKeyLength': 7, 'authenticationType': 'AUTOMATIC_PRE_SHARED_KEY', 'policies': [{'name': 'preshared_sha_des_dh5_160', 'id': '005056A9-6FFE-0ed3-0000-000000000303', 'type': 'Ike'}, {'name': 'preshared_sha_aes256_dh14_3', 'id': '005056A9-6FFE-0ed3-0000-000000000307', 'type': 'Ike'}]} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for an Ike Settings policy in a Site to Site VPN topology. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateVpnIkeSettings' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateVpnIkeSettings"
    data:
        links: {'self': '<fmc_ip>/api/fmc_config/v1/domain/domainUUID/policy/ftds2svpns/topologyUUID/ikesettings/005056A9-7483-0ed3-0000-012884902862'}
        id: "005056A9-7483-0ed3-0000-012884902862"
        type: "IkeSettings"
        ikeV2Settings: {'automaticPreSharedKeyLength': 7, 'enforceHexBasedPreSharedKeyOnly': True, 'authenticationType': 'AUTOMATIC_PRE_SHARED_KEY', 'policies': [{'name': 'DES-SHA-SHA', 'id': '005056A9-6FFE-0ed3-0000-000000000402', 'type': 'Ike2'}, {'name': 'AES-SHA-SHA', 'id': '005056A9-6FFE-0ed3-0000-000000000401', 'type': 'Ike2'}]}
        ikeV1Settings: {'automaticPreSharedKeyLength': 7, 'authenticationType': 'AUTOMATIC_PRE_SHARED_KEY', 'policies': [{'name': 'preshared_sha_des_dh5_160', 'id': '005056A9-6FFE-0ed3-0000-000000000303', 'type': 'Ike'}, {'name': 'preshared_sha_aes256_dh14_3', 'id': '005056A9-6FFE-0ed3-0000-000000000307', 'type': 'Ike'}]}
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```