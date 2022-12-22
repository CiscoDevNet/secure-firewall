# updateVrfIPv6StaticRouteModel

The updateVrfIPv6StaticRouteModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/virtualrouters/{virtualrouterUUID}/ipv6staticroutes/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/virtualrouters/{virtualrouter_uuid}/ipv6staticroutes/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv6 Static Route associated with the specified virtual router. Also, retrieves list of all IPv6 Static routes. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| interfaceName | InterfaceLogicalName |
| selectedNetworks | [{'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host1'}] |
| gateway | {'object': {'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host2'}} |
| metricValue | 50 |
| type | IPv6StaticRoute |
| isTunneled | False |
| id | ipv6StaticRouteUuid |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a IPv6 Static Route. |
| virtualrouterUUID | True | string <td colspan=3> Unique identifier of Virtual Router |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateVrfIPv6StaticRouteModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateVrfIPv6StaticRouteModel"
    data:
        interfaceName: "InterfaceLogicalName"
        selectedNetworks: [{'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host1'}]
        gateway: {'object': {'type': 'Host', 'id': 'networkHostUuid', 'name': 'Host2'}}
        metricValue: 50
        type: "IPv6StaticRoute"
        isTunneled: False
        id: "ipv6StaticRouteUuid"
    path_params:
        objectId: "{{ object_id }}"
        virtualrouterUUID: "{{ virtualrouter_uuid }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```