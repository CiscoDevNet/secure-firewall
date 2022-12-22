# updateInlineSet

The updateInlineSet operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/inlinesets/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/inlinesets/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the inline set associated with the specified NGIPS device ID and inline set ID. If no inline set ID is specified, retrieves list of all inline sets associated with the specified NGIPS device ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | Default Inline Set |
| id | inlinesetUUID |
| type | InlineSet |
| bypass | True |
| standBy | True |
| failSafe | True |
| failopen | True |
| macFiltering | False |
| inlinepairs | [{'first': {'name': 's1p1', 'type': 'FPPhysicalInterface', 'id': 'FPPhysicalInterfaceUUID1'}, 'second': {'name': 's1p2', 'type': 'FPPhysicalInterface', 'id': 'FPPhysicalInterfaceUUID2'}}] |
| loadBalancingMode | inner |
| loadBalancingModeVlan | inner |
| mtu | 1518 |
| propogateLinkState | True |
| strictTCPEnforcement | True |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of an inline set. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateInlineSet' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateInlineSet"
    data:
        name: "Default Inline Set"
        id: "inlinesetUUID"
        type: "InlineSet"
        bypass: True
        standBy: True
        failSafe: True
        failopen: True
        macFiltering: False
        inlinepairs: [{'first': {'name': 's1p1', 'type': 'FPPhysicalInterface', 'id': 'FPPhysicalInterfaceUUID1'}, 'second': {'name': 's1p2', 'type': 'FPPhysicalInterface', 'id': 'FPPhysicalInterfaceUUID2'}}]
        loadBalancingMode: "inner"
        loadBalancingModeVlan: "inner"
        mtu: 1518
        propogateLinkState: True
        strictTCPEnforcement: True
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```