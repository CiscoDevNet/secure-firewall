# getAllNetmapVuln

The getAllNetmapVuln operation handles configuration related to [/api/fmc_netmap/v1/domain/{domainUUID}/vulns](/paths//api/fmc_netmap/v1/domain/{domain_uuid}/vulns.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves a vulnerability in the Network Map**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Filters for retrieve and delete operations. The <code>source</code> filter must be included for delete.<br>Values can be any of: <code>ipAddress:192.168.1.2;source:MySource;port:443;protocol:tcp;id:12345</code> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllNetmapVuln' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllNetmapVuln"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```