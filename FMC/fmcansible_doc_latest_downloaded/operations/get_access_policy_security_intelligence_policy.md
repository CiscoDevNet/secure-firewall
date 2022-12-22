# getAccessPolicySecurityIntelligencePolicy

The getAccessPolicySecurityIntelligencePolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{containerUUID}/securityintelligencepolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{container_uuid}/securityintelligencepolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves the security intelligence policy associated with the specified Access Policy.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Security Intelligence policy associated with an Access Policy. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getAccessPolicySecurityIntelligencePolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAccessPolicySecurityIntelligencePolicy"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```