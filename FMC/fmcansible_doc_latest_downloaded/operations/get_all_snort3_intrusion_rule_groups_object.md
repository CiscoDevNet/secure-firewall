# getAllSnort3IntrusionRuleGroupsObject

The getAllSnort3IntrusionRuleGroupsObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrulegroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrulegroups.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies Snort 3 intrusion rulegroup associated with the specified ID. If no ID is specified for a GET, retrieves list of all Snort 3 intrusion group objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Value can be any of the formats (including quotes): <code>"name:Browser/Firefox"</code> or <code>"currentSecurityLevel:DISABLED"</code> or <code>"showonlyparents:{true/false}"</code> or <code>"isSystemDefined:{true/false}"</code> or <code>"includeCount:true"</code>. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllSnort3IntrusionRuleGroupsObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllSnort3IntrusionRuleGroupsObject"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```