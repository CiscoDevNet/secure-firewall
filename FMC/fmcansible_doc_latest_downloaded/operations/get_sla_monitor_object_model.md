# getSLAMonitorObjectModel

The getSLAMonitorObjectModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/slamonitors/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/slamonitors/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the sla monitor object associated with the specified ID. If no ID is specified for a GET, retrieves list of all sla monitor objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for sla monitor object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSLAMonitorObjectModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSLAMonitorObjectModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```