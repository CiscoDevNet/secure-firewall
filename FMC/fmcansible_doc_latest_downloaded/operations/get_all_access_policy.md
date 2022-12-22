# getAllAccessPolicy

The getAllAccessPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the access control policy associated with the specified ID. Also, retrieves list of all access control policies.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| name | False | string <td colspan=3> If parameter is specified, only the policy matching with the specified name will be displayed. Cannot be used if object ID is specified in path. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllAccessPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllAccessPolicy"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        name: "{{ name }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```