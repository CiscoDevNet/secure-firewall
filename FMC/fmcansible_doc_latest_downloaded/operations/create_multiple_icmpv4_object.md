# createMultipleICMPV4Object

The createMultipleICMPV4Object operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/icmpv4objects](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/icmpv4objects.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the icmpv4 object associated with the specified ID. If no ID is specified for a GET, retrieves list of all icmpv4 objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | icmpv4_obj1 |
| icmpType | 3 |
| code | 0 |
| type | ICMPV4Object |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for ICMPv4 objects. |

## Example
```yaml
- name: Execute 'createMultipleICMPV4Object' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleICMPV4Object"
    data:
        name: "icmpv4_obj1"
        icmpType: "3"
        code: 0
        type: "ICMPV4Object"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```