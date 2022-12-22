# updateIntrusionPolicy

The updateIntrusionPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/intrusionpolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/intrusionpolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the intrusion policy associated with the specified ID. Also, retrieves list of all intrusion policies. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| basePolicy | {'name': 'test1', 'id': 'intrusionPolicyUUID', 'type': 'IntrusionPolicy'} |
| description | description |
| inspectionMode | PREVENTION |
| name | test1 |
| type | IntrusionPolicy |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for intrusion policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| replicateInspectionMode | False | string <td colspan=3> Flag to replicate inspection mode from snort 3 version to snort 2 version. |
| ruleRecommendationAction | False | string <td colspan=3> This is a query parameter. Based on this value, the rule recommendation configuration is set against Snort3 Intrusion Policy.<br/>GENERATE - Generates the rule recommendation for the given recommendedSecurityLevel value and network objects per Snort3 Intrusion Policy.<br/> GENERATE_AND_ACCEPT - Generates the rule recommendation for the given recommendedSecurityLevel value and network objects per Snort3 Intrusion Policy and accepts it against the Snort3 Intrusion Policy. <br/> REFRESH - Refreshes the rule recommendation for already given recommendedSecurityLevel value and network objects per Snort3 Intrusion Policy. <br/> REMOVE - Removes all rule recommendations and ruleRecommendation config per Snort3 Intrusion Policy. <br/> ACCEPT - Accepts the rule recommendation for which rule recommendation is already generated for the given recommendedSecurityLevel value and network objects against the given Snort3 Intrusion Policy   |

## Example
```yaml
- name: Execute 'updateIntrusionPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateIntrusionPolicy"
    data:
        basePolicy: {'name': 'test1', 'id': 'intrusionPolicyUUID', 'type': 'IntrusionPolicy'}
        description: "description"
        inspectionMode: "PREVENTION"
        name: "test1"
        type: "IntrusionPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        replicateInspectionMode: "{{ replicate_inspection_mode }}"
        ruleRecommendationAction: "{{ rule_recommendation_action }}"

```