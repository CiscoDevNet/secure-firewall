# deleteIPv4StaticRouteModel

The deleteIPv4StaticRouteModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/ipv4staticroutes/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/ipv4staticroutes/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IPv4 Static Route associated with the specified ID. Also, retrieves list of all IPv4 Static routes. When device is in multi virtual router mode, this API is applicable to Global Virtual Router. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a IPv4 Static Route. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteIPv4StaticRouteModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteIPv4StaticRouteModel"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```