# updateIPv6PrefixList

The updateIPv6PrefixList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ipv6prefixlists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ipv6prefixlists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv6 Prefix List associated with the specified ID. If no ID is specified, retrieves list of all IPv6 Prefix Lists. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | IPv6PrefixListTestC |
| id | ipv6prefixlistsObjectUUID |
| entries | [{'ipAddress': 'fe83::/10', 'sequence': 35, 'maxPrefixLength': 15, 'minPrefixLenth': 14, 'action': 'PERMIT'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a IPv6 Prefix List object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateIPv6PrefixList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateIPv6PrefixList"
    data:
        name: "IPv6PrefixListTestC"
        id: "ipv6prefixlistsObjectUUID"
        entries: [{'ipAddress': 'fe83::/10', 'sequence': 35, 'maxPrefixLength': 15, 'minPrefixLenth': 14, 'action': 'PERMIT'}]
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```