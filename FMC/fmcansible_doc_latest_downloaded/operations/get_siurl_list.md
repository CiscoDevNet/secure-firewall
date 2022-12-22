# getSIURLList

The getSIURLList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/siurllists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/siurllists/{object_id}.md) path.&nbsp;
## Description
**Retrieves the Security Intelligence url list object associated with the specified ID. If no ID is specified, retrieves list of all Security Intelligence url list objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of Security Intelligence url list object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSIURLList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSIURLList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```