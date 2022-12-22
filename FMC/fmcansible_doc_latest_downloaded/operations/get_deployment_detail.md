# getDeploymentDetail

The getDeploymentDetail operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deployment/deployabledevices/{containerUUID}/deployments](/paths//api/fmc_config/v1/domain/{domain_uuid}/deployment/deployabledevices/{container_uuid}/deployments.md) path.&nbsp;
## Description
**Retrieves Deployment details for device**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Value is of format <code>startTime:start_time_in_secs;endTime:end_time_in_secs;</code>. <br/><br/><code>startTime</code> -- start time in unix format (in seconds). startTime and endTime should be specified together.<br/><code>endTime</code> -- end time in unix format (in seconds). startTime and endTime should be specified together.<br/> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getDeploymentDetail' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDeploymentDetail"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```