# deleteGeoLocationObject

The deleteGeoLocationObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/geolocations/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/geolocations/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the geolocation object associated with the specified ID. If no ID is specified, retrieves list of all geolocation objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of geolocation objects. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteGeoLocationObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteGeoLocationObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```