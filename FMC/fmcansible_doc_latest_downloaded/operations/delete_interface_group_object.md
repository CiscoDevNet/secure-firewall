# deleteInterfaceGroupObject

The deleteInterfaceGroupObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/interfacegroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/interfacegroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Interface group objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all interface group objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteInterfaceGroupObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteInterfaceGroupObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```