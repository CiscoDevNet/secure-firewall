# getAllNetmapHost

The getAllNetmapHost operation handles configuration related to [/api/fmc_netmap/v1/domain/{domainUUID}/hosts](/paths//api/fmc_netmap/v1/domain/{domain_uuid}/hosts.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves a host in the Network Map.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Filters for retrieve and delete operations. Values can be: <code>ipAddress:192.168.1.2</code> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllNetmapHost' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllNetmapHost"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```