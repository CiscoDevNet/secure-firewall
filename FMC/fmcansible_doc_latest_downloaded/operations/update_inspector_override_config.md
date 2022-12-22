# updateInspectorOverrideConfig

The updateInspectorOverrideConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/networkanalysispolicies/{containerUUID}/inspectoroverrideconfigs](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/networkanalysispolicies/{container_uuid}/inspectoroverrideconfigs.md) path.&nbsp;
## Description
**Retrieves or modifies the inspector override configuration associated with the specified policy. An inspector override allows the user to modify behaviour specified in the base policy's inspector configuration. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | InspectorOverrideConfig |
| inspectorOverrideConfig | {'rate_filter': {'enabled': True, 'type': 'singleton', 'data': []}} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateInspectorOverrideConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateInspectorOverrideConfig"
    data:
        type: "InspectorOverrideConfig"
        inspectorOverrideConfig: {'rate_filter': {'enabled': True, 'type': 'singleton', 'data': []}}
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```