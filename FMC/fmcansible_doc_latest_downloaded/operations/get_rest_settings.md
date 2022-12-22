# getRESTSettings

The getRESTSettings operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/settings/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/settings/{object_id}.md) path.&nbsp;
## Description
**API Operations on Settings objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Settings object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getRESTSettings' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getRESTSettings"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```