# updatePrefilterPolicy

The updatePrefilterPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves prefilter policy associated with the specified ID. Also, retrieves list of all prefilter policies. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for prefilter policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updatePrefilterPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updatePrefilterPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```