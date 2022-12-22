# createMultipleInterfaceGroupObject

The createMultipleInterfaceGroupObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/interfacegroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/interfacegroups.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Interface group objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all interface group objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | InterfaceGroup |
| name | InterfaceGroupObject5 |
| interfaceMode | INLINE |
| interfaces | [{'type': 'PhysicalInterface', 'id': 'Intf-UUID-1', 'name': 'eth1'}, {'type': 'PhysicalInterface', 'id': 'Intf-UUID-2', 'name': 'eth2'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for interface group objects. |

## Example
```yaml
- name: Execute 'createMultipleInterfaceGroupObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleInterfaceGroupObject"
    data:
        type: "InterfaceGroup"
        name: "InterfaceGroupObject5"
        interfaceMode: "INLINE"
        interfaces: [{'type': 'PhysicalInterface', 'id': 'Intf-UUID-1', 'name': 'eth1'}, {'type': 'PhysicalInterface', 'id': 'Intf-UUID-2', 'name': 'eth2'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```