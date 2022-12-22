# getAccessPolicyInheritanceSetting

The getAccessPolicyInheritanceSetting operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{containerUUID}/inheritancesettings/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{container_uuid}/inheritancesettings/{object_id}.md) path.&nbsp;
## Description
**Retrieves and modifies the inheritance settings associated with specified Access Policy.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Access Policy Inheritance Setting. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getAccessPolicyInheritanceSetting' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAccessPolicyInheritanceSetting"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```