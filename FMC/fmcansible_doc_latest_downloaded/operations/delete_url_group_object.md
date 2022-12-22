# deleteURLGroupObject

The deleteURLGroupObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/urlgroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/urlgroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the url group objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all url group objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteURLGroupObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteURLGroupObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```