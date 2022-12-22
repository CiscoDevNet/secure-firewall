# getHostOverride

The getHostOverride operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/hosts/{containerUUID}/overrides/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/hosts/{container_uuid}/overrides/{object_id}.md) path.&nbsp;
## Description
**Retrieves all(Domain and Device) overrides on a Host object.Response will always be in expanded form. If passed, the "expanded" query parameter will be ignored.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Input NOT Expected here |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getHostOverride' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getHostOverride"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```