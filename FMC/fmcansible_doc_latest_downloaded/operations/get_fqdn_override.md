# getFQDNOverride

The getFQDNOverride operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/fqdns/{containerUUID}/overrides/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/fqdns/{container_uuid}/overrides/{object_id}.md) path.&nbsp;
## Description
**Retrieves all(Domain and Device) overrides on a FQDN object.Response will always be in expanded form. If passed, the "expanded" query parameter will be ignored.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Input NOT Expected here |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getFQDNOverride' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getFQDNOverride"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```