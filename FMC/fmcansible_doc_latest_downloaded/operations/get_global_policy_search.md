# getGlobalPolicySearch

The getGlobalPolicySearch operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/search/policy](/paths//api/fmc_config/v1/domain/{domain_uuid}/search/policy.md) path.&nbsp;
## Description
**Search for policies matching specified text or IP address (literal values in policies)**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | True | string <td colspan=3> Text or IP address used for filtering |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getGlobalPolicySearch' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getGlobalPolicySearch"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```