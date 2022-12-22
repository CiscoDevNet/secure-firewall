# getHealthAlertModel

The getHealthAlertModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/health/alerts](/paths//api/fmc_config/v1/domain/{domain_uuid}/health/alerts.md) path.&nbsp;
## Description
**Retrieves Health Alerts.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Various filter criteria can be specified using the format <code>startTime:start_time_in_secs;endTime:end_time_in_secs;deviceUUIDs:List_of_device_uuids;status:List_of_statuses;moduleIDs:List_of_moduleIDs.</code><br/><br/><code>startTime</code> -- start time in unix format - startTime and endTime should be specified together<br/><code>endTime</code> -- end time in unix format - startTime and endTime should be specified together<br/><code>deviceUUIDs</code> -- List of device UUIDs (UUID is 0 for fmc ).<br/><code>status</code> -- List of status codes to filter delimited by comma, e.g. green,red,yellow.<br/><code>moduleIDs</code> -- List of module ids to filter, delimited by comma.<br/>. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getHealthAlertModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getHealthAlertModel"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```