# deleteRestFTDClusterDeviceContainer

The deleteRestFTDClusterDeviceContainer operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deviceclusters/ftddevicecluster/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/deviceclusters/ftddevicecluster/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the FTD Cluster record associated with the specified ID. If no ID is specified for a GET, retrieves list of all FTD Clusters. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of a FTD Cluster. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Filter to retrieve bootstrap supported clusters in case of GET operation, Delete specific nodes in case DELETE operation.<br/> eg for GET operation:clusterBootstrapSupported:true, eg for DELETE operation:dataDeviceIds:dataDeviceId1,dataDeviceId1..,<br/>  Note - Control device cannot be deleted. If no value provided for this filter, the request will proceed deletion of the whole cluster from FMC. |

## Example
```yaml
- name: Execute 'deleteRestFTDClusterDeviceContainer' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteRestFTDClusterDeviceContainer"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"

```