# getDNSPolicy

The getDNSPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/dnspolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/dnspolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves all the DNS Policies.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a DNS policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getDNSPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDNSPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```