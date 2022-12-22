# getRangeObject

The getRangeObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ranges/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ranges/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the address range object associated with the specified ID. If no ID is specified for a GET, retrieves list of all address range objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for address range. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the range object on given target ID. |

## Example
```yaml
- name: Execute 'getRangeObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getRangeObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```