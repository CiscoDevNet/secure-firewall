# createMultipleNetworkGroup

The createMultipleNetworkGroup operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/networkgroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/networkgroups.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the network group object associated with the specified ID. If no ID is specified for a GET, retrieves list of all network group objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | networkgroup_obj1 |
| objects | [{'type': 'Network', 'id': 'NetworkObjectUUID'}, {'type': 'Host', 'id': 'HostObjectUUID'}, {'type': 'Range', 'id': 'RangeObjectUUID'}] |
| literals | [{'type': 'Network', 'value': '1.2.3.0/24'}, {'type': 'Host', 'value': '1.2.3.4'}] |
| type | NetworkGroup |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for network group objects. |

## Example
```yaml
- name: Execute 'createMultipleNetworkGroup' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleNetworkGroup"
    data:
        name: "networkgroup_obj1"
        objects: [{'type': 'Network', 'id': 'NetworkObjectUUID'}, {'type': 'Host', 'id': 'HostObjectUUID'}, {'type': 'Range', 'id': 'RangeObjectUUID'}]
        literals: [{'type': 'Network', 'value': '1.2.3.0/24'}, {'type': 'Host', 'value': '1.2.3.4'}]
        type: "NetworkGroup"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```