# getPrefilterPolicy

The getPrefilterPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves prefilter policy associated with the specified ID. Also, retrieves list of all prefilter policies.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for prefilter policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getPrefilterPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getPrefilterPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```