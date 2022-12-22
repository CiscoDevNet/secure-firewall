# updateRestFTDClusterDeviceContainer

The updateRestFTDClusterDeviceContainer operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deviceclusters/ftddevicecluster/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/deviceclusters/ftddevicecluster/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the FTD Cluster record associated with the specified ID. If no ID is specified for a GET, retrieves list of all FTD Clusters. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | 35874370-9957-11e8-af35-2038dcb5d0fa |
| type | DeviceCluster |
| links | {'self': '/fmc_config/v1/domain/DomainUUID/deviceclusters/ftddevicecluster?offset=0&limit=1&expanded=true'} |
| name | <cluster_name> |
| controlDevice | {'deviceDetails': {'id': '<control_device_UUID>', 'type': 'Device'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<cclip>', 'siteId': 1, 'priority': 1}} |
| dataDevices | [{'deviceDetails': {'id': '<data1_device_UUID>', 'type': 'Device'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<cclip>', 'siteId': 1, 'priority': 2}}, {'deviceDetails': {'id': '<data2_device_UUID>', 'type': 'Device'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<cclip>', 'siteId': 1, 'priority': 3}}, {'deviceDetails': {'id': '<data3_device_UUID>', 'type': 'Device'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<cclip>', 'siteId': 1, 'priority': 4}}] |
| ftdClusterBootstrap | {'clusterGroupName': '<cluster_group_name>', 'clusterControlLink': '<cluster_control_link>', 'clusterKey': '<cluster_key>'} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of a FTD Cluster. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateRestFTDClusterDeviceContainer' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateRestFTDClusterDeviceContainer"
    data:
        id: "35874370-9957-11e8-af35-2038dcb5d0fa"
        type: "DeviceCluster"
        links: {'self': '/fmc_config/v1/domain/DomainUUID/deviceclusters/ftddevicecluster?offset=0&limit=1&expanded=true'}
        name: "<cluster_name>"
        controlDevice: {'deviceDetails': {'id': '<control_device_UUID>', 'type': 'Device'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<cclip>', 'siteId': 1, 'priority': 1}}
        dataDevices: [{'deviceDetails': {'id': '<data1_device_UUID>', 'type': 'Device'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<cclip>', 'siteId': 1, 'priority': 2}}, {'deviceDetails': {'id': '<data2_device_UUID>', 'type': 'Device'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<cclip>', 'siteId': 1, 'priority': 3}}, {'deviceDetails': {'id': '<data3_device_UUID>', 'type': 'Device'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<cclip>', 'siteId': 1, 'priority': 4}}]
        ftdClusterBootstrap: {'clusterGroupName': '<cluster_group_name>', 'clusterControlLink': '<cluster_control_link>', 'clusterKey': '<cluster_key>'}
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```