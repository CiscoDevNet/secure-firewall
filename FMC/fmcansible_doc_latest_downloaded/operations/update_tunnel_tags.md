# updateTunnelTags

The updateTunnelTags operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/tunneltags/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/tunneltags/{object_id}.md) path.&nbsp;
## Description
**Retrieves the tunnel tag object associated with the specified ID. If no ID is specified, retrieves list of all tunnel tag objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a tunnel tag. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateTunnelTags' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateTunnelTags"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```