# createDynamicAccessPolicy

The createDynamicAccessPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/dynamicaccesspolicies](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/dynamicaccesspolicies.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Dynamic Access Policy. If no ID is specified for a GET, retrieves list of all Dynamic Access Policies. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createDynamicAccessPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createDynamicAccessPolicy"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```