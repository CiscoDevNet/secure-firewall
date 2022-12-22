# createPolicyAssignment

The createPolicyAssignment operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/assignment/policyassignments](/paths//api/fmc_config/v1/domain/{domain_uuid}/assignment/policyassignments.md) path.&nbsp;
## Description
**Retrieves, creates, or modifies the policy assignments to target devices associated with the specified ID. If no ID is specified, retrieves list of all policy assignments to target devices. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | PolicyAssignment |
| policy | {'type': 'AccessPolicy', 'name': 'AccessPolicy2', 'id': 'accesspolicyUUID'} |
| targets | [{'id': 'deviceUUID1', 'type': 'Device', 'name': 'FTD_Device1'}, {'id': 'deviceUUID2', 'type': 'Device', 'name': 'FTD_Device2'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createPolicyAssignment' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createPolicyAssignment"
    data:
        type: "PolicyAssignment"
        policy: {'type': 'AccessPolicy', 'name': 'AccessPolicy2', 'id': 'accesspolicyUUID'}
        targets: [{'id': 'deviceUUID1', 'type': 'Device', 'name': 'FTD_Device1'}, {'id': 'deviceUUID2', 'type': 'Device', 'name': 'FTD_Device2'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"

```