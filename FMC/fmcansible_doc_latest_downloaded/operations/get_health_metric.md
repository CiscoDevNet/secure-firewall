# getHealthMetric

The getHealthMetric operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/health/metrics](/paths//api/fmc_config/v1/domain/{domain_uuid}/health/metrics.md) path.&nbsp;
## Description
**Retrieves HealthMonitor metrics for the device.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | True | string <td colspan=3> Various filter criteria can be specified using the format <code>deviceUUIDs:uuid1,uuid2;metric:metric_name;startTime:start_time_in_secs;endTime:end_time_in_secs;step:step_in_secs;regexFilter:filter_on_metric</code><br/><br/><code>deviceUUIDs</code> --List UUID of the device to be queried.<br/><code>metric</code> -- name of the prometheus metric to be queried.<br/><code>startTime</code> -- start time in unix format seconds.<br/><code>endTime</code> -- end time in unix format seconds.<br/><code>step</code> -- step interval in seconds over which the data is returned.<br/><code>regexFilter</code> -- filter to be applied on the metric names. Supports GO style regex e.g snort.&#42;&#124;lina.&#42; <br/><code>queryFunction</code> -- optional query function which has to be applied to the query, can be one of <code>"avg", "rate", "min", "max"</code><br/><code>rateFunctionInterval</code> -- optional interval which has to be applied to the rate function, for e.g five minutes should be specified as <code>5m</code><br/>. For e.g. to query all the memory metrics for LINA the filter parameter should be  <code>deviceUUID:&lt;uuid&gt;;metric:mem;startTime:&lt;time&gt;;endTime:&lt;time&gt;;step:60;regexFilter:used_percentage_lina</code> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getHealthMetric' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getHealthMetric"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```