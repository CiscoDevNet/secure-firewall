# createInlineSet

The createInlineSet operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/inlinesets](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/inlinesets.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the inline set associated with the specified NGIPS device ID and inline set ID. If no inline set ID is specified, retrieves list of all inline sets associated with the specified NGIPS device ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | Inline_Set_1 |
| type | InlineSet |
| bypass | True |
| standBy | True |
| failSafe | True |
| failopen | True |
| macFiltering | False |
| inlinepairs | [{'first': {'name': 's1p3', 'type': 'FPPhysicalInterface', 'id': 'FPPhysicalInterfaceUUID3'}, 'second': {'name': 's1p4', 'type': 'FPPhysicalInterface', 'id': 'FPPhysicalInterfaceUUID4'}}] |
| loadBalancingMode | inner |
| loadBalancingModeVlan | inner |
| mtu | 1518 |
| propogateLinkState | True |
| strictTCPEnforcement | True |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createInlineSet' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createInlineSet"
    data:
        name: "Inline_Set_1"
        type: "InlineSet"
        bypass: True
        standBy: True
        failSafe: True
        failopen: True
        macFiltering: False
        inlinepairs: [{'first': {'name': 's1p3', 'type': 'FPPhysicalInterface', 'id': 'FPPhysicalInterfaceUUID3'}, 'second': {'name': 's1p4', 'type': 'FPPhysicalInterface', 'id': 'FPPhysicalInterfaceUUID4'}}]
        loadBalancingMode: "inner"
        loadBalancingModeVlan: "inner"
        mtu: 1518
        propogateLinkState: True
        strictTCPEnforcement: True
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```