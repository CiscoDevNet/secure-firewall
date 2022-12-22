# getCountryObject

The getCountryObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/countries/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/countries/{object_id}.md) path.&nbsp;
## Description
**Retrieves the country object associated with the specified ID. If no ID is specified, retrieves list of all country objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of continent objects. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getCountryObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getCountryObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```