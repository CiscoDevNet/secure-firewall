# getIPv4PrefixList

The getIPv4PrefixList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ipv4prefixlists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ipv4prefixlists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv4 Prefix List associated with the specified ID. If no ID is specified, retrieves list of all IPv4 Prefix Lists.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a IPv4 Prefix List object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getIPv4PrefixList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getIPv4PrefixList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```