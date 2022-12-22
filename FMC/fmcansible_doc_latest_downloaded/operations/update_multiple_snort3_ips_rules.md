# updateMultipleSnort3IPSRules

The updateMultipleSnort3IPSRules operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/intrusionpolicies/{containerUUID}/intrusionrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/intrusionpolicies/{container_uuid}/intrusionrules.md) path.&nbsp;
## Description
**Retrieves or modifies the per-policy behaviour of the specified intrusion rule ID for the target intrusion policy ID. If no rule ID is specified for a GET, retrieves list of all Snort 3 intrusion rules associated with the policy ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| sid | 37062 |
| gid | 1 |
| revision | 2 |
| msg | "APP-DETECT 12P DNS request attempt" |
| ruleData | alert udp $HOME_NET any -> any 53 ( msg:"APP-DETECT 12P DNS request attempt"; flow:to_server; byte_test:1,!&,0xF8,2; content:"|03|b32|03|i2p|00|",fast_pattern,nocase; metadata:policy max-detect-ips drop; service:dns; reference:url,geti2p.net; classtype:misc-activity; sid:37062; rev:2; ) |
| isSystemDefined | false | true |
| ruleAction | [{'defaultState': 'BLOCK', 'overrideState': 'ALERT', 'policy': {'name': 'Maximum Detection', 'id': 'ccbf50d8-b908-5a56-b1a8-099773b904f2', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}, {'defaultState': 'DISABLE', 'overrideState': 'BLOCK', 'policy': {'name': 'Balanced Security and Connectivity', 'id': '6c5fd197-7d58-51cc-b048-40f5a7442f4b', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}, {'defaultState': 'DISABLE', 'overrideState': 'ALERT', 'policy': {'name': 'Connectivity Over Security', 'id': 'e90b3402-1dde-58b8-956e-0ba3e73b9c0a', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}, {'defaultState': 'DISABLE', 'overrideState': 'DISABLE', 'policy': {'name': 'No Rules Active', 'id': '402cd584-98f0-544e-b628-0c4b40903189', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}, {'defaultState': 'DISABLE', 'overrideState': 'BLOCK', 'policy': {'name': 'Security Over Connectivity', 'id': 'eb508df4-58a2-59c3-a610-500d9a9e4423', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}] |
| name |   |
| description | "APP-DETECT 12P DNS request attempt" |
| id | Snort3IPSRules-UUID-1 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | True | boolean <td colspan=3> This parameter specifies that bulk operation is being used in the query. This parameter is required for bulk Snort 3 intrusion rule operations. |

## Example
```yaml
- name: Execute 'updateMultipleSnort3IPSRules' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateMultipleSnort3IPSRules"
    data:
        sid: 37062
        gid: 1
        revision: 2
        msg: ""APP-DETECT 12P DNS request attempt""
        ruleData: "alert udp $HOME_NET any -> any 53 ( msg:"APP-DETECT 12P DNS request attempt"; flow:to_server; byte_test:1,!&,0xF8,2; content:"|03|b32|03|i2p|00|",fast_pattern,nocase; metadata:policy max-detect-ips drop; service:dns; reference:url,geti2p.net; classtype:misc-activity; sid:37062; rev:2; )"
        isSystemDefined: "false | true"
        ruleAction: [{'defaultState': 'BLOCK', 'overrideState': 'ALERT', 'policy': {'name': 'Maximum Detection', 'id': 'ccbf50d8-b908-5a56-b1a8-099773b904f2', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}, {'defaultState': 'DISABLE', 'overrideState': 'BLOCK', 'policy': {'name': 'Balanced Security and Connectivity', 'id': '6c5fd197-7d58-51cc-b048-40f5a7442f4b', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}, {'defaultState': 'DISABLE', 'overrideState': 'ALERT', 'policy': {'name': 'Connectivity Over Security', 'id': 'e90b3402-1dde-58b8-956e-0ba3e73b9c0a', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}, {'defaultState': 'DISABLE', 'overrideState': 'DISABLE', 'policy': {'name': 'No Rules Active', 'id': '402cd584-98f0-544e-b628-0c4b40903189', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}, {'defaultState': 'DISABLE', 'overrideState': 'BLOCK', 'policy': {'name': 'Security Over Connectivity', 'id': 'eb508df4-58a2-59c3-a610-500d9a9e4423', 'type': 'IntrusionPolicy', 'inlineDrop': 0}}]
        name: " "
        description: ""APP-DETECT 12P DNS request attempt""
        id: "Snort3IPSRules-UUID-1"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```