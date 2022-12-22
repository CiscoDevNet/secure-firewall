# updateVlanTag

The updateVlanTag operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/vlantags/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/vlantags/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the vlantag objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all vlantag objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| data | {'startTag': 10, 'endTag': 20, 'type': 'VlanTagLiteral'} |
| type | VlanTag |
| overridable | True |
| overrides | {'parent': {'id': 'vlan1_uuid', 'type': 'VlanTag'}, 'target': {'name': '10.10.16.29', 'id': 'target_uuid', 'type': 'Device'}} |
| description |   |
| id | vlan1_uuid |
| name | vlan1 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateVlanTag' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateVlanTag"
    data:
        data: {'startTag': 10, 'endTag': 20, 'type': 'VlanTagLiteral'}
        type: "VlanTag"
        overridable: True
        overrides: {'parent': {'id': 'vlan1_uuid', 'type': 'VlanTag'}, 'target': {'name': '10.10.16.29', 'id': 'target_uuid', 'type': 'Device'}}
        description: " "
        id: "vlan1_uuid"
        name: "vlan1"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```