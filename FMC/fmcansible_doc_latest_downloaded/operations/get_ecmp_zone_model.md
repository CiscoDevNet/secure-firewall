# getECMPZoneModel

The getECMPZoneModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/ecmpzones/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/ecmpzones/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the ECMP Zone associated with the specified ID. Also, retrieves list of all ECMP Zone. **

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a ECMP Zone. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getECMPZoneModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getECMPZoneModel"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```