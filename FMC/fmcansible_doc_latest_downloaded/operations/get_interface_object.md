# getInterfaceObject

The getInterfaceObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/interfaceobjects/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/interfaceobjects/{object_id}.md) path.&nbsp;
## Description
**Retrieves list of all the interface objects both security zones and interface groups.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getInterfaceObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getInterfaceObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```