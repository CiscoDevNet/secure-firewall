# getIdentityPolicy

The getIdentityPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/identitypolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/identitypolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves the Identity Policy associated with the specified ID. If no ID is specified, retrieves list of all Identity Policies.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of an Identity Policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getIdentityPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getIdentityPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```