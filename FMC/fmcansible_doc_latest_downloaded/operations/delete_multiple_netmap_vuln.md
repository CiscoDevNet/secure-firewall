# deleteMultipleNetmapVuln

The deleteMultipleNetmapVuln operation handles configuration related to [/api/fmc_netmap/v1/domain/{domainUUID}/vulns](/paths//api/fmc_netmap/v1/domain/{domain_uuid}/vulns.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves a vulnerability in the Network Map _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | True | boolean <td colspan=3> Enables bulk create or delete. <br>This field must be true in order to delete with a filter rather than an identifier. |
| filter | True | string <td colspan=3> Filters for retrieve and delete operations. The <code>source</code> filter must be included for delete.<br>Values can be any of: <code>ipAddress:192.168.1.2;source:MySource;port:443;protocol:tcp;id:12345</code> |

## Example
```yaml
- name: Execute 'deleteMultipleNetmapVuln' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteMultipleNetmapVuln"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"
        filter: "{{ filter }}"

```