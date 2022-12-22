# getRouteMap

The getRouteMap operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/routemaps/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/routemaps/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates or modifies the RouteMap with the specified ID. If no ID is specified, retrieves all RouteMap objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a RouteMap object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getRouteMap' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getRouteMap"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```