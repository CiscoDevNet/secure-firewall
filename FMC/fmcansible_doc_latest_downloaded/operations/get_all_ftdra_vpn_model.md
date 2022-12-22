# getAllFTDRAVpnModel

The getAllFTDRAVpnModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ravpns](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ravpns.md) path.&nbsp;
## Description
**Retrieves the FTD RA VPN topology associated with the specified ID. If no ID is specified for a GET, retrieves list of all FTD RA VPN topologies.**

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
- name: Execute 'getAllFTDRAVpnModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllFTDRAVpnModel"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```