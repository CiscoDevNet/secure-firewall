# getURLObject

The getURLObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/urls/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/urls/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the url objects associated with the specified ID. If no ID is specified, retrieves list of all url objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the url object on given target ID. |

## Example
```yaml
- name: Execute 'getURLObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getURLObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```