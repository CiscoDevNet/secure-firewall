# getAllFTDHAInterfaceMACAddresses

The getAllFTDHAInterfaceMACAddresses operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devicehapairs/ftddevicehapairs/{containerUUID}/failoverinterfacemacaddressconfigs](/paths//api/fmc_config/v1/domain/{domain_uuid}/devicehapairs/ftddevicehapairs/{container_uuid}/failoverinterfacemacaddressconfigs.md) path.&nbsp;
## Description
**Retrieves or modifies the FTD HA failover policy interface MAC addresses record associated with the specified FTD HA pair. If no ID is specified for a GET, retrieves list of all FTD HA failover policy interface MAC addresses records.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllFTDHAInterfaceMACAddresses' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllFTDHAInterfaceMACAddresses"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```