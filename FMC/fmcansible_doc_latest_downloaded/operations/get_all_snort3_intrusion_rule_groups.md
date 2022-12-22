# getAllSnort3IntrusionRuleGroups

The getAllSnort3IntrusionRuleGroups operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/intrusionpolicies/{containerUUID}/intrusionrulegroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/intrusionpolicies/{container_uuid}/intrusionrulegroups.md) path.&nbsp;
## Description
**Retrieves or modifies the per-policy behaviour of the specified intrusion rule ID for the target intrusion policy ID. If no rule ID is specified for a GET, retrieves list of all Snort 3 intrusion rulegroups associated with the policy ID.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| includeCount | False | string <td colspan=3> Boolean value if the count of rules should be calculated in the response. |
| filter | False | string <td colspan=3> Value can be any of the formats (including quotes): <code>"name:Browser/Firefox"</code> or <code>"currentSecurityLevel:DISABLED"</code> or <code>"showonlyparents:{true/false}"</code> or <code>"isSystemDefined:{true/false}"</code> or <code>"includeCount:true"</code>. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllSnort3IntrusionRuleGroups' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllSnort3IntrusionRuleGroups"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        includeCount: "{{ include_count }}"
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```