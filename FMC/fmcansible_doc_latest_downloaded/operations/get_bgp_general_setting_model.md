# getBGPGeneralSettingModel

The getBGPGeneralSettingModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/bgpgeneralsettings/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/bgpgeneralsettings/{object_id}.md) path.&nbsp;
## Description
**Retrieves BGP general settings associated with the specified device.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a BGP general settings. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getBGPGeneralSettingModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getBGPGeneralSettingModel"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```