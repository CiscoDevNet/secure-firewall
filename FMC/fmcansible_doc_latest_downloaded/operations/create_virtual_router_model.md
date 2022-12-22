# createVirtualRouterModel

The createVirtualRouterModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/virtualrouters](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/virtualrouters.md) path.&nbsp;
## Description
**Retrieves list of all virtual routers created in the specified device. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | VirtualRouter |
| name | Beta |
| description | Human Resource Department Virtual Router |
| interfaces | [{'id': 'interface_uuid1', 'type': 'PhysicalInterface', 'name': 'OUTSIDE'}, {'id': 'interface_uuid2', 'type': 'SubInterface', 'name': 'OUTSIDE-SUB'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createVirtualRouterModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createVirtualRouterModel"
    data:
        type: "VirtualRouter"
        name: "Beta"
        description: "Human Resource Department Virtual Router"
        interfaces: [{'id': 'interface_uuid1', 'type': 'PhysicalInterface', 'name': 'OUTSIDE'}, {'id': 'interface_uuid2', 'type': 'SubInterface', 'name': 'OUTSIDE-SUB'}]
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```