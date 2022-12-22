# getExternalStorage

The getExternalStorage operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/integration/externalstorage/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/integration/externalstorage/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the external event storage config.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for an external event storage config. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getExternalStorage' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getExternalStorage"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```