# getFMCManagedChassis

The getFMCManagedChassis operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/chassis/fmcmanagedchassis/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/chassis/fmcmanagedchassis/{object_id}.md) path.&nbsp;
## Description
**Retrieves list of all chassis managed devices from FMC.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a chassis. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getFMCManagedChassis' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getFMCManagedChassis"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```