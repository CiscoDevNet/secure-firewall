# getServerVersion

The getServerVersion operation handles configuration related to [/api/fmc_platform/v1/info/serverversion/{objectId}](/paths//api/fmc_platform/v1/info/serverversion/{object_id}.md) path.&nbsp;
## Description
**API Operation for Server Version.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |

## Example
```yaml
- name: Execute 'getServerVersion' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getServerVersion"
    path_params:
        objectId: "{{ object_id }}"

```