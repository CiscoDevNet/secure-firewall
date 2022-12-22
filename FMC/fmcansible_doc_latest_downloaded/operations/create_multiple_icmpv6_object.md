# createMultipleICMPV6Object

The createMultipleICMPV6Object operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/icmpv6objects](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/icmpv6objects.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the icmpv6 object associated with the specified ID. If no ID is specified for a GET, retrieves list of all icmpv6 objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | icmpv6_obj1 |
| icmpType | 3 |
| code | 0 |
| type | ICMPV6Object |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for ICMPv6 objects. |

## Example
```yaml
- name: Execute 'createMultipleICMPV6Object' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleICMPV6Object"
    data:
        name: "icmpv6_obj1"
        icmpType: "3"
        code: 0
        type: "ICMPV6Object"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```