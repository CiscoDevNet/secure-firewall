# createMultipleNetmapVuln

The createMultipleNetmapVuln operation handles configuration related to [/api/fmc_netmap/v1/domain/{domainUUID}/vulns](/paths//api/fmc_netmap/v1/domain/{domain_uuid}/vulns.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves a vulnerability in the Network Map _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | 12345 |
| type | Vuln |
| ipAddress | 192.168.1.2 |
| source | MyVulnSource |
| cve | 2021-12345 |
| description | Description of the vuln |
| protocol | tcp |
| port | 443 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create or delete. <br>This field must be true in order to delete with a filter rather than an identifier. |

## Example
```yaml
- name: Execute 'createMultipleNetmapVuln' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleNetmapVuln"
    data:
        id: "12345"
        type: "Vuln"
        ipAddress: "192.168.1.2"
        source: "MyVulnSource"
        cve: "2021-12345"
        description: "Description of the vuln"
        protocol: "tcp"
        port: 443
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```