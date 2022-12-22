# createMultipleVlanTag

The createMultipleVlanTag operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/vlantags](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/vlantags.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the vlantag objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all vlantag objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | VlanTag |
| name | vlanobj1 |
| description | New VlanTag test |
| data | {'startTag': 12, 'endTag': 15} |
| type | VlanTag |
| name | vlanobj2 |
| description | New VlanTag test |
| data | {'startTag': 112, 'endTag': 151} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for vlan tag objects. |

## Example
```yaml
- name: Execute 'createMultipleVlanTag' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleVlanTag"
    data:
        type: "VlanTag"
        name: "vlanobj1"
        description: "New VlanTag test"
        data: {'startTag': 12, 'endTag': 15}
        type: "VlanTag"
        name: "vlanobj2"
        description: "New VlanTag test"
        data: {'startTag': 112, 'endTag': 151}
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```