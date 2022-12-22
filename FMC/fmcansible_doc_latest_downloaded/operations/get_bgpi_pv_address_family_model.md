# getBGPIPvAddressFamilyModel

The getBGPIPvAddressFamilyModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/bgp/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/bgp/{object_id}.md) path.&nbsp;
## Description
**Retrieves list of all BGP (ipv4 and ipv6) associated with the specified device. When device is in multi virtual router mode, this API is applicable to Global Virtual Router.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a BGP (ipv4 or ipv6) model. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getBGPIPvAddressFamilyModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getBGPIPvAddressFamilyModel"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```