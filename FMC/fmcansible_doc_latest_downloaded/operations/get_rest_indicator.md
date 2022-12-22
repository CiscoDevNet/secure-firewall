# getRESTIndicator

The getRESTIndicator operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/indicator/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/indicator/{object_id}.md) path.&nbsp;
## Description
**API Operations on Indicator objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Indicator. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getRESTIndicator' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getRESTIndicator"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```