# getRESTObservable

The getRESTObservable operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/observable/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/observable/{object_id}.md) path.&nbsp;
## Description
**API Operations on Observable objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Observable. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getRESTObservable' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getRESTObservable"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```