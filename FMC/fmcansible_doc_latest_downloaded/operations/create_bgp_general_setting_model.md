# createBGPGeneralSettingModel

The createBGPGeneralSettingModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/bgpgeneralsettings](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/bgpgeneralsettings.md) path.&nbsp;
## Description
**Retrieves BGP general settings associated with the specified device. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | String |
| asNumber | String |
| logNeighborChanges | boolean |
| maxasLimit | Integer |
| transportPathMtuDiscovery | boolean |
| fastExternalFallOver | boolean |
| enforceFirstAs | boolean |
| asnotationDot | boolean |
| bgptimers | {'keepAlive': 'Integer', 'holdTime': 'Integer', 'minHoldTime': 'Integer', 'type': 'bgptimers'} |
| bgpGracefulRestart | {'gracefulRestart': 'boolean', 'gracefulRestartRestartTime': 'Integer', 'gracefulRestartStalePathTime': 'Integer', 'type': 'bgpgracefulrestart'} |
| bestPath | {'defaultLocalPreferenceValue': 'Long', 'alwaysCompareMed': 'boolean', 'bestPathCompareRouterId': 'boolean', 'deterministicMed': 'boolean', 'bestPathMedMissingAsWorst': 'boolean', 'type': 'bgpbestpath'} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createBGPGeneralSettingModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createBGPGeneralSettingModel"
    data:
        name: "String"
        asNumber: "String"
        logNeighborChanges: "boolean"
        maxasLimit: "Integer"
        transportPathMtuDiscovery: "boolean"
        fastExternalFallOver: "boolean"
        enforceFirstAs: "boolean"
        asnotationDot: "boolean"
        bgptimers: {'keepAlive': 'Integer', 'holdTime': 'Integer', 'minHoldTime': 'Integer', 'type': 'bgptimers'}
        bgpGracefulRestart: {'gracefulRestart': 'boolean', 'gracefulRestartRestartTime': 'Integer', 'gracefulRestartStalePathTime': 'Integer', 'type': 'bgpgracefulrestart'}
        bestPath: {'defaultLocalPreferenceValue': 'Long', 'alwaysCompareMed': 'boolean', 'bestPathCompareRouterId': 'boolean', 'deterministicMed': 'boolean', 'bestPathMedMissingAsWorst': 'boolean', 'type': 'bgpbestpath'}
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```