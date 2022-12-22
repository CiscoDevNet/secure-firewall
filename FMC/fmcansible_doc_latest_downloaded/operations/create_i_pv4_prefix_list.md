# createIPv4PrefixList

The createIPv4PrefixList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ipv4prefixlists](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ipv4prefixlists.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv4 Prefix List associated with the specified ID. If no ID is specified, retrieves list of all IPv4 Prefix Lists. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | IPv4PrefixListTestC |
| entries | [{'ipAddress': '11.11.11.11/20', 'sequence': 50, 'maxPrefixLength': 24, 'minPrefixLenth': 22, 'action': 'PERMIT'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createIPv4PrefixList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createIPv4PrefixList"
    data:
        name: "IPv4PrefixListTestC"
        entries: [{'ipAddress': '11.11.11.11/20', 'sequence': 50, 'maxPrefixLength': 24, 'minPrefixLenth': 22, 'action': 'PERMIT'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"

```