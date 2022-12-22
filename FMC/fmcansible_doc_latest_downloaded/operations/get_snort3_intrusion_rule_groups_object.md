# getSnort3IntrusionRuleGroupsObject

The getSnort3IntrusionRuleGroupsObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrulegroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrulegroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies Snort 3 intrusion rulegroup associated with the specified ID. If no ID is specified for a GET, retrieves list of all Snort 3 intrusion group objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of a Snort 3 intrusion rulegroup. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSnort3IntrusionRuleGroupsObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSnort3IntrusionRuleGroupsObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```