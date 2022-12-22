# getICMPV6ObjectOverride

The getICMPV6ObjectOverride operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/icmpv6objects/{containerUUID}/overrides/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/icmpv6objects/{container_uuid}/overrides/{object_id}.md) path.&nbsp;
## Description
**&#91;DEV ERROR: Missing description&#93;**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> [DEV ERROR: Missing description] |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getICMPV6ObjectOverride' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getICMPV6ObjectOverride"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```