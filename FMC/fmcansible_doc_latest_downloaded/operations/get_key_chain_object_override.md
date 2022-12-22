# getKeyChainObjectOverride

The getKeyChainObjectOverride operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/keychains/{containerUUID}/overrides/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/keychains/{container_uuid}/overrides/{object_id}.md) path.&nbsp;
## Description
**Retrieves all(Domain and Device) overrides on a KeyChain object.Response will always be in expanded form. If passed, the "expanded" query parameter will be ignored.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Input NOT Expected here |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getKeyChainObjectOverride' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getKeyChainObjectOverride"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```