# getAuditModel

The getAuditModel operation handles configuration related to [/api/fmc_platform/v1/domain/{domainUUID}/audit/auditrecords/{objectId}](/paths//api/fmc_platform/v1/domain/{domain_uuid}/audit/auditrecords/{object_id}.md) path.&nbsp;
## Description
**API Operations on audit objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getAuditModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAuditModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```