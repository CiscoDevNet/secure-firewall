# getAllRestFTDClusterDeviceContainer

The getAllRestFTDClusterDeviceContainer operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deviceclusters/ftddevicecluster](/paths//api/fmc_config/v1/domain/{domain_uuid}/deviceclusters/ftddevicecluster.md) path.&nbsp;
## Description
**Retrieves or modifies the FTD Cluster record associated with the specified ID. If no ID is specified for a GET, retrieves list of all FTD Clusters.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Filter to retrieve bootstrap supported clusters in case of GET operation, Delete specific nodes in case DELETE operation.<br/> eg for GET operation:clusterBootstrapSupported:true, eg for DELETE operation:dataDeviceIds:dataDeviceId1,dataDeviceId1..,<br/>  Note - Control device cannot be deleted. If no value provided for this filter, the request will proceed deletion of the whole cluster from FMC. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllRestFTDClusterDeviceContainer' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllRestFTDClusterDeviceContainer"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```