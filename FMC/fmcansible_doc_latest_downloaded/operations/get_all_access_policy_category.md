# getAllAccessPolicyCategory

The getAllAccessPolicyCategory operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{containerUUID}/categories](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{container_uuid}/categories.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the category associated with the specified policy ID. If no ID is specified, retrieves list of all categories associated with the specified policy ID.**

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
- name: Execute 'getAllAccessPolicyCategory' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllAccessPolicyCategory"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```