# getAllowDNSRule

The getAllowDNSRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/dnspolicies/{containerUUID}/allowdnsrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/dnspolicies/{container_uuid}/allowdnsrules.md) path.&nbsp;
## Description
**Retrieves all the allow rules for a given DNS Policy.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Filter criteria can be specified using the format <code>name:rule_name</code><br/><br/><code>name</code> -- Name of the allow rule to be queried <br/> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllowDNSRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllowDNSRule"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```