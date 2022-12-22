# getJobHistory

The getJobHistory operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deployment/jobhistories/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/deployment/jobhistories/{object_id}.md) path.&nbsp;
## Description
**Retrieves all the deployment jobs.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Job ID to be edited. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getJobHistory' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getJobHistory"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```