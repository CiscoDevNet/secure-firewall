# getAllFTDRAVpnAddressAssignmentSetting

The getAllFTDRAVpnAddressAssignmentSetting operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ravpns/{containerUUID}/addressassignmentsettings](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ravpns/{container_uuid}/addressassignmentsettings.md) path.&nbsp;
## Description
**Retrieves Address Assignment Setting inside a VPN RA Topology. If no ID is specified for a GET, retrieves list containing a single Address Assignment Setting entry of the topology.**

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
- name: Execute 'getAllFTDRAVpnAddressAssignmentSetting' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllFTDRAVpnAddressAssignmentSetting"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```