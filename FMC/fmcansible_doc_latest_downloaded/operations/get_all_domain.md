# getAllDomain

The getAllDomain operation handles configuration related to [/api/fmc_platform/v1/info/domain](/paths//api/fmc_platform/v1/info/domain.md) path.&nbsp;
## Description
**API Operation for Domains.**

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllDomain' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllDomain"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```