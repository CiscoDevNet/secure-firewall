# getExtendedCommunityListOverride

The getExtendedCommunityListOverride operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/extendedcommunitylists/{containerUUID}/overrides/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/extendedcommunitylists/{container_uuid}/overrides/{object_id}.md) path.&nbsp;
## Description
**Retrieves all(Domain and Device) overrides on a ExtendedCommunityList object.Response will always be in expanded form. If passed, the "expanded" query parameter will be ignored.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> UUID of the ExtendedCommunityList object. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getExtendedCommunityListOverride' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getExtendedCommunityListOverride"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```