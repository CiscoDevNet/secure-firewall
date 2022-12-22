# deleteIntrusionPolicy

The deleteIntrusionPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/intrusionpolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/intrusionpolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the intrusion policy associated with the specified ID. Also, retrieves list of all intrusion policies. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for intrusion policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteIntrusionPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteIntrusionPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```