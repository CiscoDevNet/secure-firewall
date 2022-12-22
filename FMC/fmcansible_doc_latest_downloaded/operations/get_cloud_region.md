# getCloudRegion

The getCloudRegion operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/integration/cloudregions/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/integration/cloudregions/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the cloud region configuration associated with the specified ID. If no ID is specified for a GET, retrieves list of all cloud regions.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for a cloud region. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getCloudRegion' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getCloudRegion"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```