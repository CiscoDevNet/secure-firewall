# getAllJobHistory

The getAllJobHistory operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deployment/jobhistories](/paths//api/fmc_config/v1/domain/{domain_uuid}/deployment/jobhistories.md) path.&nbsp;
## Description
**Retrieves all the deployment jobs.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Various filter criteria can be specified using the format <code>deviceUUID:{uuid};startTime:start_time_in_secs;endTime:end_time_in_secs;rollbackApplicable:true_or_false</code>.  <br/><br/><code>startTime</code> -- start time in unix format (in seconds). startTime and endTime should be specified together.<br/><br/><code>endTime</code> -- end time in unix format (in seconds). startTime and endTime should be specified together.<br/><br/><code>rollbackApplicable</code> -- true/false. Not a mandatory field. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllJobHistory' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllJobHistory"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```