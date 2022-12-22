# getAllICMPV6ObjectOverride

The getAllICMPV6ObjectOverride operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/icmpv6objects/{containerUUID}/overrides](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/icmpv6objects/{container_uuid}/overrides.md) path.&nbsp;
## Description
**&#91;DEV ERROR: Missing description&#93;**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllICMPV6ObjectOverride' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllICMPV6ObjectOverride"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```