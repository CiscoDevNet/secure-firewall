# getAllFTDHADeviceContainer

The getAllFTDHADeviceContainer operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devicehapairs/ftddevicehapairs](/paths//api/fmc_config/v1/domain/{domain_uuid}/devicehapairs/ftddevicehapairs.md) path.&nbsp;
## Description
**Retrieves or modifies the FTD HA record associated with the specified ID. Creates or breaks or deletes a FTD HA pair. If no ID is specified for a GET, retrieves list of all FTD HA pairs.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllFTDHADeviceContainer' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllFTDHADeviceContainer"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```