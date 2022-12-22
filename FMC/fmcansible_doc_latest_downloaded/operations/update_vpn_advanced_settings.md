# updateVpnAdvancedSettings

The updateVpnAdvancedSettings operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns/{containerUUID}/advancedsettings/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns/{container_uuid}/advancedsettings/{object_id}.md) path.&nbsp;
## Description
**Retrieves and modifies a Advanced settings inside a VPN Site To Site Topology. If no ID is specified for a GET, retrieves list containing a single AdvancedSettings entry of the topology. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | 005056A9-097E-0ed3-0000-021474836554 |
| type | AdvancedSettings |
| links | {'self': '<fmc_url>/api/fmc_config/v1/domain/e276abec-e0f2-11e3-8169-6d9ed49b625f/policy/ftds2svpns/005056A9-097E-0ed3-0000-008589935150/advancedsettings/005056A9-097E-0ed3-0000-021474836554'} |
| advancedIkeSetting | {'peerIdentityValidation': 'REQUIRED', 'thresholdToChallengeIncomingCookies': 50, 'percentageOfSAsAllowedInNegotiation': 100, 'enableNotificationOnTunnelDisconnect': False, 'identitySentToPeer': 'AUTO_OR_DN', 'enableAggressiveMode': False, 'cookieChallenge': 'CUSTOM'} |
| advancedTunnelSetting | {'certificateMapSettings': {'useCertMapConfiguredInEndpointToDetermineTunnel': False, 'useCertificateOuToDetermineTunnel': True, 'useIkeIdentityOuToDetermineTunnel': True, 'usePeerIpAddressToDetermineTunnel': True}, 'enableSpokeToSpokeConnectivityThroughHub': False, 'natKeepaliveMessageTraversal': {'enabled': True, 'intervalSeconds': 20}, 'bypassAccessControlTrafficForDecryptedTraffic': False} |
| advancedIpsecSetting | {'maximumTransmissionUnitAging': {'enabled': False}, 'enableFragmentationBeforeEncryption': True} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for Advanced settings in a Site to Site VPN topology. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateVpnAdvancedSettings' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateVpnAdvancedSettings"
    data:
        id: "005056A9-097E-0ed3-0000-021474836554"
        type: "AdvancedSettings"
        links: {'self': '<fmc_url>/api/fmc_config/v1/domain/e276abec-e0f2-11e3-8169-6d9ed49b625f/policy/ftds2svpns/005056A9-097E-0ed3-0000-008589935150/advancedsettings/005056A9-097E-0ed3-0000-021474836554'}
        advancedIkeSetting: {'peerIdentityValidation': 'REQUIRED', 'thresholdToChallengeIncomingCookies': 50, 'percentageOfSAsAllowedInNegotiation': 100, 'enableNotificationOnTunnelDisconnect': False, 'identitySentToPeer': 'AUTO_OR_DN', 'enableAggressiveMode': False, 'cookieChallenge': 'CUSTOM'}
        advancedTunnelSetting: {'certificateMapSettings': {'useCertMapConfiguredInEndpointToDetermineTunnel': False, 'useCertificateOuToDetermineTunnel': True, 'useIkeIdentityOuToDetermineTunnel': True, 'usePeerIpAddressToDetermineTunnel': True}, 'enableSpokeToSpokeConnectivityThroughHub': False, 'natKeepaliveMessageTraversal': {'enabled': True, 'intervalSeconds': 20}, 'bypassAccessControlTrafficForDecryptedTraffic': False}
        advancedIpsecSetting: {'maximumTransmissionUnitAging': {'enabled': False}, 'enableFragmentationBeforeEncryption': True}
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```