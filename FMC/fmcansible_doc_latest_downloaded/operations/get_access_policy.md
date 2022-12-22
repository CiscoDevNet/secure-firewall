# getAccessPolicy

The getAccessPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the access control policy associated with the specified ID. Also, retrieves list of all access control policies.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for access control policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getAccessPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAccessPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```