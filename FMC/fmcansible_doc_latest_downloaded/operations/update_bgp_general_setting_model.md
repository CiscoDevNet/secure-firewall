# updateBGPGeneralSettingModel

The updateBGPGeneralSettingModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/bgpgeneralsettings/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/bgpgeneralsettings/{object_id}.md) path.&nbsp;
## Description
**Retrieves BGP general settings associated with the specified device. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | bgpGeneralSettingsUUID |
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
| objectId | True | string <td colspan=3> Unique identifier of a BGP general settings. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateBGPGeneralSettingModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateBGPGeneralSettingModel"
    data:
        id: "bgpGeneralSettingsUUID"
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
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```