# createFTDClusterDeviceCommandContainer

The createFTDClusterDeviceCommandContainer operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deviceclusters/{containerUUID}/operational/ftdclusterdevicecommands](/paths//api/fmc_config/v1/domain/{domain_uuid}/deviceclusters/{container_uuid}/operational/ftdclusterdevicecommands.md) path.&nbsp;
## Description
**Executes given command on the FTD Cluster. For eg: enable cluster, disable cluster, make control. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | True | string <td colspan=3> Filter are <code>operation</code> and <code>deviceUUID</code>. Value of filter is of format:<code>deviceUUID:device uuid;operation:{enable|disable|control}</code>. <code>'deviceUUID'</code> is UUID of device and is a mandatory field. <code>'operation'</code> is the command that needs to be executed on device and is a mandatory field. |

## Example
```yaml
- name: Execute 'createFTDClusterDeviceCommandContainer' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createFTDClusterDeviceCommandContainer"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"

```