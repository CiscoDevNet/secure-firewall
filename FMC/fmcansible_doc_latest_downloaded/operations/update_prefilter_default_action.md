# updatePrefilterDefaultAction

The updatePrefilterDefaultAction operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies/{containerUUID}/defaultactions/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies/{container_uuid}/defaultactions/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the default action associated with the specified prefilter control policy ID and default action ID. If no default action ID is specified, retrieves list of all default actions associated with the specified prefilter policy ID. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a default action. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updatePrefilterDefaultAction' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updatePrefilterDefaultAction"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```