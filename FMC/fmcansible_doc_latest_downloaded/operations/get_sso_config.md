# getSSOConfig

The getSSOConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/users/ssoconfigs/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/users/ssoconfigs/{object_id}.md) path.&nbsp;
## Description
**Retrieves, creates, or modifies the SSO configuration associated with the specified ID. If no ID is specified for a GET, retrieves list of all SSO configurations.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the SSO configuration. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSSOConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSSOConfig"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```