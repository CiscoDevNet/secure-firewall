# getAllICMPV4Object

The getAllICMPV4Object operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/icmpv4objects](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/icmpv4objects.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the icmpv4 object associated with the specified ID. If no ID is specified for a GET, retrieves list of all icmpv4 objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> To be used in conjunction with <code>"unusedOnly:true"</code> to search for unused objects and <code>"nameOrValue:{nameOrValue}"</code> to search for both name and value. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllICMPV4Object' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllICMPV4Object"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```