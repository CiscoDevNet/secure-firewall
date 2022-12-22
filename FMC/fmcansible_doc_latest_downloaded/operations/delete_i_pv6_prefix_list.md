# deleteIPv6PrefixList

The deleteIPv6PrefixList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ipv6prefixlists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ipv6prefixlists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv6 Prefix List associated with the specified ID. If no ID is specified, retrieves list of all IPv6 Prefix Lists. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a IPv6 Prefix List object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteIPv6PrefixList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteIPv6PrefixList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```