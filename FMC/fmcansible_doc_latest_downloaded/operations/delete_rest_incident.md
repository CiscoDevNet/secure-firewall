# deleteRESTIncident

The deleteRESTIncident operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/incident/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/incident/{object_id}.md) path.&nbsp;
## Description
**API Operations on Incident objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Incident. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteRESTIncident' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteRESTIncident"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```