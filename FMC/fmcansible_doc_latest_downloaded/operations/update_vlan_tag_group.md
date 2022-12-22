# updateVlanTagGroup

The updateVlanTagGroup operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/vlangrouptags/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/vlangrouptags/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the vlan group tag objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all vlan group tag objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | vlanGroupObj1UUID |
| name | vlangroup_obj1_updated |
| type | VlanGroupTag |
| objects | [{'type': 'VlanTag', 'id': 'vlanObjectUUID'}] |
| literals | [{'type': 'Vlan', 'startTag': 'valid_tag', 'endTag': 'valid_tag'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateVlanTagGroup' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateVlanTagGroup"
    data:
        id: "vlanGroupObj1UUID"
        name: "vlangroup_obj1_updated"
        type: "VlanGroupTag"
        objects: [{'type': 'VlanTag', 'id': 'vlanObjectUUID'}]
        literals: [{'type': 'Vlan', 'startTag': 'valid_tag', 'endTag': 'valid_tag'}]
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```