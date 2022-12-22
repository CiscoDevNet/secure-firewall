# createMultipleNetmapHost

The createMultipleNetmapHost operation handles configuration related to [/api/fmc_netmap/v1/domain/{domainUUID}/hosts](/paths//api/fmc_netmap/v1/domain/{domain_uuid}/hosts.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves a host in the Network Map. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | Host |
| ipAddress | ['192.168.1.2'] |
| macAddress | AA:BB:CC:DD:EE:FF |

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
- name: Execute 'createMultipleNetmapHost' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleNetmapHost"
    data:
        type: "Host"
        ipAddress: ['192.168.1.2']
        macAddress: "AA:BB:CC:DD:EE:FF"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```