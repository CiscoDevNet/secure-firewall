# createGeoLocationObject

The createGeoLocationObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/geolocations](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/geolocations.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the geolocation object associated with the specified ID. If no ID is specified, retrieves list of all geolocation objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createGeoLocationObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createGeoLocationObject"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```