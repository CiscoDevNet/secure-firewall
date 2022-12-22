# updateJobHistory

The updateJobHistory operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deployment/jobhistories/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/deployment/jobhistories/{object_id}.md) path.&nbsp;
## Description
**Retrieves all the deployment jobs. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | 0050568B-9937-0ed3-0000-463856468766 |
| deploymentNote | Updated note |
| type | JobHistory |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Job ID to be edited. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateJobHistory' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateJobHistory"
    data:
        id: "0050568B-9937-0ed3-0000-463856468766"
        deploymentNote: "Updated note"
        type: "JobHistory"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```