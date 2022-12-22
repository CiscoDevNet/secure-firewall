# getAllSIURLList

The getAllSIURLList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/siurllists](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/siurllists.md) path.&nbsp;
## Description
**Retrieves the Security Intelligence url list object associated with the specified ID. If no ID is specified, retrieves list of all Security Intelligence url list objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllSIURLList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllSIURLList"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```