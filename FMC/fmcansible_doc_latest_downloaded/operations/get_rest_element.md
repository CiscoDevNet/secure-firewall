# getRESTElement

The getRESTElement operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/element/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/element/{object_id}.md) path.&nbsp;
## Description
**API Operations on Element objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Element. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getRESTElement' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getRESTElement"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```