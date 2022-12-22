# getGroupPolicyModel

The getGroupPolicyModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/grouppolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/grouppolicies/{object_id}.md) path.&nbsp;
## Description
**Defines  the group policies for VPN**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Group policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getGroupPolicyModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getGroupPolicyModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```