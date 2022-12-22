# deleteVrfIPv4StaticRouteModel

The deleteVrfIPv4StaticRouteModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/virtualrouters/{virtualrouterUUID}/ipv4staticroutes/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/virtualrouters/{virtualrouter_uuid}/ipv4staticroutes/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv4 Static Route associated with the specified virtual router. Also, retrieves list of all IPv4 Static routes. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a IPv4 Static Route. |
| virtualrouterUUID | True | string <td colspan=3> Unique identifier of Virtual Router |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteVrfIPv4StaticRouteModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteVrfIPv4StaticRouteModel"
    path_params:
        objectId: "{{ object_id }}"
        virtualrouterUUID: "{{ virtualrouter_uuid }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```