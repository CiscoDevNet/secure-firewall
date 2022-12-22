# createVrfIPv4StaticRouteModel

The createVrfIPv4StaticRouteModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/virtualrouters/{virtualrouterUUID}/ipv4staticroutes](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/virtualrouters/{virtualrouter_uuid}/ipv4staticroutes.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv4 Static Route associated with the specified virtual router. Also, retrieves list of all IPv4 Static routes. _Check the response section for applicable examples (if any)._**

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
| virtualrouterUUID | True | string <td colspan=3> Unique identifier of Virtual Router |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createVrfIPv4StaticRouteModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createVrfIPv4StaticRouteModel"
    data:
        interfaceName: "InterfaceLogicalName"
        selectedNetworks: [{'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host1'}]
        gateway: {'object': {'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host2'}}
        routeTracking: {'type': 'SLAMonitor', 'name': 'sla1', 'id': 'sla_monitor_id'}
        metricValue: 22
        type: "IPv4StaticRoute"
        isTunneled: False
    path_params:
        virtualrouterUUID: "{{ virtualrouter_uuid }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```