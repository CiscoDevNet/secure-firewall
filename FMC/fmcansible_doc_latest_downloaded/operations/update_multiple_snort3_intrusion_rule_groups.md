# updateMultipleSnort3IntrusionRuleGroups

The updateMultipleSnort3IntrusionRuleGroups operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/intrusionpolicies/{containerUUID}/intrusionrulegroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/intrusionpolicies/{container_uuid}/intrusionrulegroups.md) path.&nbsp;
## Description
**Retrieves or modifies the per-policy behaviour of the specified intrusion rule ID for the target intrusion policy ID. If no rule ID is specified for a GET, retrieves list of all Snort 3 intrusion rulegroups associated with the policy ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | Group1 |
| id | bb79c3d4-904e-569e-80ba-ad50a8f24a67 |
| type | IntrusionRuleGroup |
| defaultSecurityLevel | DISABLED |
| description | A description about Group1 goes here. |
| overrideSecurityLevel | LEVEL_1 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | True | boolean <td colspan=3> This parameter specifies that bulk operation is being used in the query. This parameter is required for bulk Snort 3 rulegroup operations. |

## Example
```yaml
- name: Execute 'updateMultipleSnort3IntrusionRuleGroups' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateMultipleSnort3IntrusionRuleGroups"
    data:
        name: "Group1"
        id: "bb79c3d4-904e-569e-80ba-ad50a8f24a67"
        type: "IntrusionRuleGroup"
        defaultSecurityLevel: "DISABLED"
        description: "A description about Group1 goes here."
        overrideSecurityLevel: "LEVEL_1"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```