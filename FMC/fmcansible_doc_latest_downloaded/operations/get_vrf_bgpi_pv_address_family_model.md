# getVrfBGPIPvAddressFamilyModel

The getVrfBGPIPvAddressFamilyModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/virtualrouters/{virtualrouterUUID}/bgp/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/virtualrouters/{virtualrouter_uuid}/bgp/{object_id}.md) path.&nbsp;
## Description
**Retrieves list of all BGP (ipv4 and ipv6) associated with the specified device for specified vrf.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a BGP general settings. |
| virtualrouterUUID | True | string <td colspan=3> Unique identifier of Virtual Router |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getVrfBGPIPvAddressFamilyModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getVrfBGPIPvAddressFamilyModel"
    path_params:
        objectId: "{{ object_id }}"
        virtualrouterUUID: "{{ virtualrouter_uuid }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```