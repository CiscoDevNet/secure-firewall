# deleteRESTTidSource

The deleteRESTTidSource operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/source/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/source/{object_id}.md) path.&nbsp;
## Description
**API Operations on Source objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Source. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteRESTTidSource' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteRESTTidSource"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```