# getNetmapVuln

The getNetmapVuln operation handles configuration related to [/api/fmc_netmap/v1/domain/{domainUUID}/vulns/{objectId}](/paths//api/fmc_netmap/v1/domain/{domain_uuid}/vulns/{object_id}.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves a vulnerability in the Network Map**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Integer identifier of the vulnerability |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getNetmapVuln' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getNetmapVuln"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```