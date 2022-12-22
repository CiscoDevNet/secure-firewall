# getIntrusionPolicy

The getIntrusionPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/intrusionpolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/intrusionpolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the intrusion policy associated with the specified ID. Also, retrieves list of all intrusion policies.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for intrusion policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| includeCount | False | string <td colspan=3> Boolean value if the count of rules should be calculated in the response. |
| ruleFilter | False | string <td colspan=3> [DEV ERROR: Missing description] |

## Example
```yaml
- name: Execute 'getIntrusionPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getIntrusionPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        includeCount: "{{ include_count }}"
        ruleFilter: "{{ rule_filter }}"

```