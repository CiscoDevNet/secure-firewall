# getSnort3IntrusionRuleGroups

The getSnort3IntrusionRuleGroups operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/intrusionpolicies/{containerUUID}/intrusionrulegroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/intrusionpolicies/{container_uuid}/intrusionrulegroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the per-policy behaviour of the specified intrusion rule ID for the target intrusion policy ID. If no rule ID is specified for a GET, retrieves list of all Snort 3 intrusion rulegroups associated with the policy ID.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of a Snort 3 rulegroup. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSnort3IntrusionRuleGroups' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSnort3IntrusionRuleGroups"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```