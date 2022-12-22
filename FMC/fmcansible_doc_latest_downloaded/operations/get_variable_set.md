# getVariableSet

The getVariableSet operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/variablesets/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/variablesets/{object_id}.md) path.&nbsp;
## Description
**Retrieves the variable set object associated with the specified ID. If no ID is specified, retrieves list of all variable set objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the variable set object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getVariableSet' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getVariableSet"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```