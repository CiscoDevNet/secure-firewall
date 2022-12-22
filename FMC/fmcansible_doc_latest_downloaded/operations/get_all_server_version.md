# getAllServerVersion

The getAllServerVersion operation handles configuration related to [/api/fmc_platform/v1/info/serverversion](/paths//api/fmc_platform/v1/info/serverversion.md) path.&nbsp;
## Description
**API Operation for Server Version.**

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllServerVersion' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllServerVersion"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```