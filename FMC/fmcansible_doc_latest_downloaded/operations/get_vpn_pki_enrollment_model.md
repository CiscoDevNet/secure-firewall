# getVpnPKIEnrollmentModel

The getVpnPKIEnrollmentModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/certenrollments/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/certenrollments/{object_id}.md) path.&nbsp;
## Description
**Retrieves the Cert Enrollment object associated with the specified ID. If no ID is specified for a GET, retrieves list of all PKI enrollment objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for Cert Enrollment object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getVpnPKIEnrollmentModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getVpnPKIEnrollmentModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```