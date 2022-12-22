# getAllPacketTracerPCAPFiles

The getAllPacketTracerPCAPFiles operation handles configuration related to [/api/fmc_troubleshoot/v1/domain/{domainUUID}/packettracer/files](/paths//api/fmc_troubleshoot/v1/domain/{domain_uuid}/packettracer/files.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves PCAP files from FMC.**

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
- name: Execute 'getAllPacketTracerPCAPFiles' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllPacketTracerPCAPFiles"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```