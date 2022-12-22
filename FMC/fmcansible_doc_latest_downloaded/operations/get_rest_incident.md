# getRESTIncident

The getRESTIncident operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/incident/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/incident/{object_id}.md) path.&nbsp;
## Description
**API Operations on Incident objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Incident. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getRESTIncident' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getRESTIncident"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```