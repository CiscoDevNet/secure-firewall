# createMultiplePortObjectGroup

The createMultiplePortObjectGroup operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/portobjectgroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/portobjectgroups.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the port object group object associated with the specified ID. If no ID is specified for a GET, retrieves list of all port object group objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | portgroup_obj1 |
| objects | [{'type': 'ICMPV4Object', 'id': 'ICMPV4ObjectUUID'}, {'id': 'ICMPV6ObjectUUID', 'type': 'ICMPV6Object'}, {'id': 'ProtocolPortObjectUUID', 'type': 'ProtocolPortObject'}] |
| type | PortObjectGroup |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for port group objects. |

## Example
```yaml
- name: Execute 'createMultiplePortObjectGroup' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultiplePortObjectGroup"
    data:
        name: "portgroup_obj1"
        objects: [{'type': 'ICMPV4Object', 'id': 'ICMPV4ObjectUUID'}, {'id': 'ICMPV6ObjectUUID', 'type': 'ICMPV6Object'}, {'id': 'ProtocolPortObjectUUID', 'type': 'ProtocolPortObject'}]
        type: "PortObjectGroup"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```