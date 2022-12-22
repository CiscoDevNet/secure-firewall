# updatePolicyAssignment

The updatePolicyAssignment operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/assignment/policyassignments/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/assignment/policyassignments/{object_id}.md) path.&nbsp;
## Description
**Retrieves, creates, or modifies the policy assignments to target devices associated with the specified ID. If no ID is specified, retrieves list of all policy assignments to target devices. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | PolicyAssignment |
| id | policyassignmentUUID |
| policy | {'type': 'AccessPolicy', 'name': 'AccessPolicy1', 'id': 'accesspolicyUUID'} |
| targets | [{'id': 'deviceUUID', 'type': 'Device', 'name': 'FTD_Device1'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a policy assignment. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updatePolicyAssignment' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updatePolicyAssignment"
    data:
        type: "PolicyAssignment"
        id: "policyassignmentUUID"
        policy: {'type': 'AccessPolicy', 'name': 'AccessPolicy1', 'id': 'accesspolicyUUID'}
        targets: [{'id': 'deviceUUID', 'type': 'Device', 'name': 'FTD_Device1'}]
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```