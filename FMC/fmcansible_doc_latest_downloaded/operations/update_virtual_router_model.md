# updateVirtualRouterModel

The updateVirtualRouterModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/virtualrouters/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/virtualrouters/{object_id}.md) path.&nbsp;
## Description
**Retrieves list of all virtual routers created in the specified device. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | VirtualRouter |
| name | Beta |
| description | Human Resource Department Virtual Router |
| id | virtualrouterUuid |
| interfaces | [{'id': 'interface_uuid1', 'type': 'PhysicalInterface', 'name': 'OUTSIDE'}, {'id': 'interface_uuid2', 'type': 'SubInterface', 'name': 'OUTSIDE-SUB'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a Virtual Router |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateVirtualRouterModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateVirtualRouterModel"
    data:
        type: "VirtualRouter"
        name: "Beta"
        description: "Human Resource Department Virtual Router"
        id: "virtualrouterUuid"
        interfaces: [{'id': 'interface_uuid1', 'type': 'PhysicalInterface', 'name': 'OUTSIDE'}, {'id': 'interface_uuid2', 'type': 'SubInterface', 'name': 'OUTSIDE-SUB'}]
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```