# getAccessPolicyLoggingSettingModel

The getAccessPolicyLoggingSettingModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{containerUUID}/loggingsettings/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{container_uuid}/loggingsettings/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the logging setting associated with the specified access control policy ID and default action ID. If no default action ID is specified, retrieves list of all default actions associated with the specified access control policy ID.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a logging setting. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getAccessPolicyLoggingSettingModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAccessPolicyLoggingSettingModel"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```