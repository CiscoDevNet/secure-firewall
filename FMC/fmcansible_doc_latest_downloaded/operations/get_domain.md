# getDomain

The getDomain operation handles configuration related to [/api/fmc_platform/v1/info/domain/{domainUUID}/{objectId}](/paths//api/fmc_platform/v1/info/domain/{domain_uuid}/{object_id}.md) path.&nbsp;
## Description
**API Operation for Domains.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the domain. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getDomain' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDomain"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```