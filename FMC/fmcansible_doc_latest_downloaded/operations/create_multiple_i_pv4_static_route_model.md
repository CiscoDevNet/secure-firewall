# createMultipleIPv4StaticRouteModel

The createMultipleIPv4StaticRouteModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/ipv4staticroutes](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/ipv4staticroutes.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv4 Static Route associated with the specified ID. Also, retrieves list of all IPv4 Static routes. When device is in multi virtual router mode, this API is applicable to Global Virtual Router. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| interfaceName | InterfaceLogicalName |
| selectedNetworks | [{'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host1'}] |
| gateway | {'object': {'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host2'}} |
| routeTracking | {'type': 'SLAMonitor', 'name': 'sla1', 'id': 'sla_monitor_id'} |
| metricValue | 22 |
| type | IPv4StaticRoute |
| isTunneled | False |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for IPv4 static routes. |

## Example
```yaml
- name: Execute 'createMultipleIPv4StaticRouteModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleIPv4StaticRouteModel"
    data:
        interfaceName: "InterfaceLogicalName"
        selectedNetworks: [{'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host1'}]
        gateway: {'object': {'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host2'}}
        routeTracking: {'type': 'SLAMonitor', 'name': 'sla1', 'id': 'sla_monitor_id'}
        metricValue: 22
        type: "IPv4StaticRoute"
        isTunneled: False
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```