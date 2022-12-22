# getVlanTag

The getVlanTag operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/vlantags/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/vlantags/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the vlantag objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all vlantag objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the vlantag object on given target ID. |

## Example
```yaml
- name: Execute 'getVlanTag' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getVlanTag"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```