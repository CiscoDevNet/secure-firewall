# getAllRESTElement

The getAllRESTElement operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/element](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/element.md) path.&nbsp;
## Description
**API Operations on Element objects.**

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
- name: Execute 'getAllRESTElement' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllRESTElement"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```