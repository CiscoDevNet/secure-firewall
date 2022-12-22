# deleteDeviceGroup

The deleteDeviceGroup operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devicegroups/devicegrouprecords/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devicegroups/devicegrouprecords/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the device group associated with the specified ID. If no ID is specified for a GET, retrieves list of all device groups. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for a device group. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteDeviceGroup' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteDeviceGroup"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```