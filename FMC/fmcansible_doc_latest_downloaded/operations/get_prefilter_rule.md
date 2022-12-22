# getPrefilterRule

The getPrefilterRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies/{containerUUID}/prefilterrules/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies/{container_uuid}/prefilterrules/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the prefilter rule associated with the specified policy ID and rule ID. If no ID is specified, retrieves list of all prefilter rules associated with the specified policy ID.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a prefilter rule. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getPrefilterRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getPrefilterRule"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```