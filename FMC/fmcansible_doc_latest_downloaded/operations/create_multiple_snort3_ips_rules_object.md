# createMultipleSnort3IPSRulesObject

The createMultipleSnort3IPSRulesObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrules.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies Snort 3 intrusion rule associated with the specified ID. If no ID is specified for a GET, retrieves list of all Snort 3 intrusion rules. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | IntrusionRule |
| ruleData | alert icmp any any -> any any ( sid:10000301; gid:2000; msg:"CUSTOM RULE1"; classtype:icmp-event; rev:1; ) |
| ruleGroups | [{'name': 'CUSTOM_RULES', 'id': '0050568A-7769-0ed3-0000-008589940030', 'type': 'IntrusionRuleGroup'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> This parameter specifies that bulk operation is being used in the query. This parameter is required for bulk Snort 3 intrusion rule operations. |

## Example
```yaml
- name: Execute 'createMultipleSnort3IPSRulesObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleSnort3IPSRulesObject"
    data:
        type: "IntrusionRule"
        ruleData: "alert icmp any any -> any any ( sid:10000301; gid:2000; msg:"CUSTOM RULE1"; classtype:icmp-event; rev:1; )"
        ruleGroups: [{'name': 'CUSTOM_RULES', 'id': '0050568A-7769-0ed3-0000-008589940030', 'type': 'IntrusionRuleGroup'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```