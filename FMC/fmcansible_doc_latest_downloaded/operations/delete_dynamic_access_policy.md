# deleteDynamicAccessPolicy

The deleteDynamicAccessPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/dynamicaccesspolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/dynamicaccesspolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Dynamic Access Policy. If no ID is specified for a GET, retrieves list of all Dynamic Access Policies. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for Dynamic Access Policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteDynamicAccessPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteDynamicAccessPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```