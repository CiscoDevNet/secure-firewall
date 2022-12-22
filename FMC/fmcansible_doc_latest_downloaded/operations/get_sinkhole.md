# getSinkhole

The getSinkhole operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/sinkholes/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/sinkholes/{object_id}.md) path.&nbsp;
## Description
**APIs for Sinkhole.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for Sinkhole. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSinkhole' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSinkhole"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```