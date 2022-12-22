# createMultipleSnort3IntrusionRuleGroupsObject

The createMultipleSnort3IntrusionRuleGroupsObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrulegroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrulegroups.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies Snort 3 intrusion rulegroup associated with the specified ID. If no ID is specified for a GET, retrieves list of all Snort 3 intrusion group objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| description | Custom Intrusion Rule group1 |
| name | Custom RuleGroup 1 |
| type | IntrusionRuleGroup |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> This parameter specifies that bulk operation is being used in the query. This parameter is required for bulk Snort 3 rulegroup operations. |

## Example
```yaml
- name: Execute 'createMultipleSnort3IntrusionRuleGroupsObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleSnort3IntrusionRuleGroupsObject"
    data:
        description: "Custom Intrusion Rule group1"
        name: "Custom RuleGroup 1"
        type: "IntrusionRuleGroup"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```