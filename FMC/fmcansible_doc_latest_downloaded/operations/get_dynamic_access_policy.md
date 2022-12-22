# getDynamicAccessPolicy

The getDynamicAccessPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/dynamicaccesspolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/dynamicaccesspolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Dynamic Access Policy. If no ID is specified for a GET, retrieves list of all Dynamic Access Policies.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for Dynamic Access Policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getDynamicAccessPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDynamicAccessPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```