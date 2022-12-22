# getURLGroupObject

The getURLGroupObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/urlgroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/urlgroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the url group objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all url group objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the url group object on given target ID. |

## Example
```yaml
- name: Execute 'getURLGroupObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getURLGroupObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```