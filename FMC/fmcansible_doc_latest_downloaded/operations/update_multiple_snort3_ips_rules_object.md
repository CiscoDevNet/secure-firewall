# updateMultipleSnort3IPSRulesObject

The updateMultipleSnort3IPSRulesObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrules.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies Snort 3 intrusion rule associated with the specified ID. If no ID is specified for a GET, retrieves list of all Snort 3 intrusion rules. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | IntrusionRule |
| id | 0050568A-7769-0ed3-0000-008589940125 |
| name | 2000:10000301 |
| gid | 2000 |
| sid | 10000301 |
| revision | 1 |
| isSystemDefined | False |
| msg | CUSTOM RULE1 |
| ruleData | alert icmp any any -> any any ( sid:10000301; gid:2000; msg:"CUSTOM RULE1"; classtype:icmp-event; rev:1; ) |
| ruleAction | [{'defaultState': 'DISABLE', 'policy': {'name': 'ips3', 'id': '0050568A-7769-0ed3-0000-008589939827', 'type': 'IntrusionPolicy', 'isSystemDefined': False}}, {'defaultState': 'DISABLE', 'policy': {'name': 'IPS', 'id': '0050568A-7769-0ed3-0000-008589936387', 'type': 'IntrusionPolicy', 'isSystemDefined': False}}, {'defaultState': 'DISABLE', 'policy': {'name': 'ips2', 'id': '0050568A-7769-0ed3-0000-008589939444', 'type': 'IntrusionPolicy', 'isSystemDefined': False}}, {'defaultState': 'DISABLE', 'policy': {'name': 'Maximum Detection', 'id': '3c7d3f87-c264-504e-9a16-4a9cd5fc502c', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}, {'defaultState': 'DISABLE', 'policy': {'name': 'Security Over Connectivity', 'id': '0f9e8294-d03d-5b1f-a70c-549ca9213405', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}, {'defaultState': 'DISABLE', 'policy': {'name': 'Balanced Security and Connectivity', 'id': '6c66b83c-bc23-55b6-879d-c4d847443503', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}, {'defaultState': 'DISABLE', 'policy': {'name': 'Connectivity Over Security', 'id': '4cba6c52-6a07-54cd-a324-5bb7be06a484', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}, {'defaultState': 'DISABLE', 'policy': {'name': 'No Rules Active', 'id': 'ba8dc24f-f2a4-53dc-86b3-5252e5682579', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}] |
| ruleGroups | [{'name': 'CUSTOM_RULES', 'id': '0050568A-7769-0ed3-0000-008589940030', 'type': 'IntrusionRuleGroup'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | True | boolean <td colspan=3> This parameter specifies that bulk operation is being used in the query. This parameter is required for bulk Snort 3 intrusion rule operations. |

## Example
```yaml
- name: Execute 'updateMultipleSnort3IPSRulesObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateMultipleSnort3IPSRulesObject"
    data:
        type: "IntrusionRule"
        id: "0050568A-7769-0ed3-0000-008589940125"
        name: "2000:10000301"
        gid: 2000
        sid: 10000301
        revision: 1
        isSystemDefined: False
        msg: "CUSTOM RULE1"
        ruleData: "alert icmp any any -> any any ( sid:10000301; gid:2000; msg:"CUSTOM RULE1"; classtype:icmp-event; rev:1; )"
        ruleAction: [{'defaultState': 'DISABLE', 'policy': {'name': 'ips3', 'id': '0050568A-7769-0ed3-0000-008589939827', 'type': 'IntrusionPolicy', 'isSystemDefined': False}}, {'defaultState': 'DISABLE', 'policy': {'name': 'IPS', 'id': '0050568A-7769-0ed3-0000-008589936387', 'type': 'IntrusionPolicy', 'isSystemDefined': False}}, {'defaultState': 'DISABLE', 'policy': {'name': 'ips2', 'id': '0050568A-7769-0ed3-0000-008589939444', 'type': 'IntrusionPolicy', 'isSystemDefined': False}}, {'defaultState': 'DISABLE', 'policy': {'name': 'Maximum Detection', 'id': '3c7d3f87-c264-504e-9a16-4a9cd5fc502c', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}, {'defaultState': 'DISABLE', 'policy': {'name': 'Security Over Connectivity', 'id': '0f9e8294-d03d-5b1f-a70c-549ca9213405', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}, {'defaultState': 'DISABLE', 'policy': {'name': 'Balanced Security and Connectivity', 'id': '6c66b83c-bc23-55b6-879d-c4d847443503', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}, {'defaultState': 'DISABLE', 'policy': {'name': 'Connectivity Over Security', 'id': '4cba6c52-6a07-54cd-a324-5bb7be06a484', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}, {'defaultState': 'DISABLE', 'policy': {'name': 'No Rules Active', 'id': 'ba8dc24f-f2a4-53dc-86b3-5252e5682579', 'type': 'IntrusionPolicy', 'isSystemDefined': True}}]
        ruleGroups: [{'name': 'CUSTOM_RULES', 'id': '0050568A-7769-0ed3-0000-008589940030', 'type': 'IntrusionRuleGroup'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```