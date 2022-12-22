# updateCloudRegion

The updateCloudRegion operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/integration/cloudregions/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/integration/cloudregions/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the cloud region configuration associated with the specified ID. If no ID is specified for a GET, retrieves list of all cloud regions. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | cloudRegionUUID |
| type | CloudRegion |
| current | True |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for a cloud region. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateCloudRegion' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateCloudRegion"
    data:
        id: "cloudRegionUUID"
        type: "CloudRegion"
        current: True
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```