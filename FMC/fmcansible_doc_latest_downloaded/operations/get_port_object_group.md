# getPortObjectGroup

The getPortObjectGroup operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/portobjectgroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/portobjectgroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the port object group object associated with the specified ID. If no ID is specified for a GET, retrieves list of all port object group objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the port object group. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the port group object on given target ID. |

## Example
```yaml
- name: Execute 'getPortObjectGroup' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getPortObjectGroup"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```