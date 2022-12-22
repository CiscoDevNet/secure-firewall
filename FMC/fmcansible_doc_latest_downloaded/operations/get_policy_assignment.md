# getPolicyAssignment

The getPolicyAssignment operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/assignment/policyassignments/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/assignment/policyassignments/{object_id}.md) path.&nbsp;
## Description
**Retrieves, creates, or modifies the policy assignments to target devices associated with the specified ID. If no ID is specified, retrieves list of all policy assignments to target devices.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a policy assignment. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getPolicyAssignment' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getPolicyAssignment"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```