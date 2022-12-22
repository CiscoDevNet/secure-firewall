# deleteRangeObject

The deleteRangeObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ranges/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ranges/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the address range object associated with the specified ID. If no ID is specified for a GET, retrieves list of all address range objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for address range. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteRangeObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteRangeObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```