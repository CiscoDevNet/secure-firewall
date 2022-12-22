# createRestFTDClusterDeviceContainer

The createRestFTDClusterDeviceContainer operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deviceclusters/ftddevicecluster](/paths//api/fmc_config/v1/domain/{domain_uuid}/deviceclusters/ftddevicecluster.md) path.&nbsp;
## Description
**Retrieves or modifies the FTD Cluster record associated with the specified ID. If no ID is specified for a GET, retrieves list of all FTD Clusters. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | DeviceCluster |
| links | {'self': '/fmc_config/v1/domain/DomainUUID/deviceclusters/ftddevicecluster?offset=0&limit=1&expanded=true'} |
| name | <cluster_name> |
| controlDevice | {'deviceDetails': {'id': '<control_device_UUID>', 'type': 'Device', 'name': '<Device_name>'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<127.2.0.1>', 'siteId': 1, 'priority': 1}} |
| dataDevices | [{'deviceDetails': {'id': '<data1_device_UUID>', 'type': 'Device', 'name': '<Device_name>'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<127.2.0.2>', 'siteId': 2, 'priority': 2}}, {'deviceDetails': {'id': '<data2_device_UUID>', 'type': 'Device', 'name': '<Device_name>'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<127.2.0.3>', 'siteId': 3, 'priority': 3}}] |
| commonBootstrap | {'clusterKey': '<cluster_key>', 'cclNetwork': '<subnet_mask>', 'cclInterface': {'id': '<Interface_UUID>', 'type': 'PhysicalInterface', 'name': '<Ethernetx/x>'}} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createRestFTDClusterDeviceContainer' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createRestFTDClusterDeviceContainer"
    data:
        type: "DeviceCluster"
        links: {'self': '/fmc_config/v1/domain/DomainUUID/deviceclusters/ftddevicecluster?offset=0&limit=1&expanded=true'}
        name: "<cluster_name>"
        controlDevice: {'deviceDetails': {'id': '<control_device_UUID>', 'type': 'Device', 'name': '<Device_name>'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<127.2.0.1>', 'siteId': 1, 'priority': 1}}
        dataDevices: [{'deviceDetails': {'id': '<data1_device_UUID>', 'type': 'Device', 'name': '<Device_name>'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<127.2.0.2>', 'siteId': 2, 'priority': 2}}, {'deviceDetails': {'id': '<data2_device_UUID>', 'type': 'Device', 'name': '<Device_name>'}, 'clusterNodeBootstrap': {'localUnit': '<localUnit>', 'cclIp': '<127.2.0.3>', 'siteId': 3, 'priority': 3}}]
        commonBootstrap: {'clusterKey': '<cluster_key>', 'cclNetwork': '<subnet_mask>', 'cclInterface': {'id': '<Interface_UUID>', 'type': 'PhysicalInterface', 'name': '<Ethernetx/x>'}}
    path_params:
        domainUUID: "{{ domain_uuid }}"

```