# deleteNetworkGroup

The deleteNetworkGroup operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/networkgroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/networkgroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the network group object associated with the specified ID. If no ID is specified for a GET, retrieves list of all network group objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for a network group. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteNetworkGroup' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteNetworkGroup"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```