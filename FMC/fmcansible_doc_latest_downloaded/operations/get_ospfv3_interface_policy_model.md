# getOspfv3InterfacePolicyModel

The getOspfv3InterfacePolicyModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/ospfv3interfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/ospfv3interfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves list of OSPF v3 process. Also, deletes, creates, or modifies the OSPFv3 Interface associated with the specified ID.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a OSPFv3 Interface Policy. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getOspfv3InterfacePolicyModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getOspfv3InterfacePolicyModel"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```