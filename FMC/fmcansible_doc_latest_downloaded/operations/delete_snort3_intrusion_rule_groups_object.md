# deleteSnort3IntrusionRuleGroupsObject

The deleteSnort3IntrusionRuleGroupsObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrulegroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrulegroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies Snort 3 intrusion rulegroup associated with the specified ID. If no ID is specified for a GET, retrieves list of all Snort 3 intrusion group objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of a Snort 3 intrusion rulegroup. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| cascadeDeleteOrphanedRules | False | string <td colspan=3> Boolean value for deleting orphan rule. Mandatory if custom rulegroup has unique/unshared rules which becomes orphan after custom rule Group delete. |

## Example
```yaml
- name: Execute 'deleteSnort3IntrusionRuleGroupsObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteSnort3IntrusionRuleGroupsObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        cascadeDeleteOrphanedRules: "{{ cascade_delete_orphaned_rules }}"

```