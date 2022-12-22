# deleteNetmapHost

The deleteNetmapHost operation handles configuration related to [/api/fmc_netmap/v1/domain/{domainUUID}/hosts/{objectId}](/paths//api/fmc_netmap/v1/domain/{domain_uuid}/hosts/{object_id}.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves a host in the Network Map. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique UUID identifier of the host. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteNetmapHost' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteNetmapHost"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```