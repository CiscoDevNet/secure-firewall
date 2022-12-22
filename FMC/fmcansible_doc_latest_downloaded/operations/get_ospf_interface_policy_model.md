# getOspfInterfacePolicyModel

The getOspfInterfacePolicyModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/ospfinterface/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/ospfinterface/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the OSPF Interface associated with the specified ID. Also, retrieves list of all OSPF v2 process. When device is in multi virtual router mode, this API is applicable to Global Virtual Router.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a OSPF Interface Policy. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getOspfInterfacePolicyModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getOspfInterfacePolicyModel"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```