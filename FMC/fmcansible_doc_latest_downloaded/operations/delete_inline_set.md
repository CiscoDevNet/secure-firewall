# deleteInlineSet

The deleteInlineSet operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/inlinesets/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/inlinesets/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the inline set associated with the specified NGIPS device ID and inline set ID. If no inline set ID is specified, retrieves list of all inline sets associated with the specified NGIPS device ID. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of an inline set. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteInlineSet' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteInlineSet"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```