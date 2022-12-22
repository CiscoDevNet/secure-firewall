# getDuoConfig

The getDuoConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/users/duoconfigs/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/users/duoconfigs/{object_id}.md) path.&nbsp;
## Description
**Retrieves, creates, or modifies the Duo configuration associated with the specified ID. If no ID is specified for a GET, retrieves list of all Duo configurations.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Duo configuration. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getDuoConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDuoConfig"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```