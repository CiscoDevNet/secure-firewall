# createIPv6PrefixList

The createIPv6PrefixList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ipv6prefixlists](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ipv6prefixlists.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv6 Prefix List associated with the specified ID. If no ID is specified, retrieves list of all IPv6 Prefix Lists. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | IPv6PrefixListTestC |
| entries | [{'ipAddress': 'fe83::abcd/50', 'sequence': 130, 'maxPrefixLength': 70, 'minPrefixLenth': 60, 'action': 'PERMIT'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createIPv6PrefixList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createIPv6PrefixList"
    data:
        name: "IPv6PrefixListTestC"
        entries: [{'ipAddress': 'fe83::abcd/50', 'sequence': 130, 'maxPrefixLength': 70, 'minPrefixLenth': 60, 'action': 'PERMIT'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"

```