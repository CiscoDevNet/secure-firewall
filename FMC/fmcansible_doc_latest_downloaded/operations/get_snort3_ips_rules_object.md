# getSnort3IPSRulesObject

The getSnort3IPSRulesObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrules/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrules/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies Snort 3 intrusion rule associated with the specified ID. If no ID is specified for a GET, retrieves list of all Snort 3 intrusion rules.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of a Snort 3 intrusion rule. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSnort3IPSRulesObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSnort3IPSRulesObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```