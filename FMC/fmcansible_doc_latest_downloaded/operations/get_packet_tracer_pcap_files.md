# getPacketTracerPCAPFiles

The getPacketTracerPCAPFiles operation handles configuration related to [/api/fmc_troubleshoot/v1/domain/{domainUUID}/packettracer/files/{pcapFileName}](/paths//api/fmc_troubleshoot/v1/domain/{domain_uuid}/packettracer/files/{pcap_file_name}.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves PCAP files from FMC.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| pcapFileName | True | string <td colspan=3> Specify the PCAP file name. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getPacketTracerPCAPFiles' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getPacketTracerPCAPFiles"
    path_params:
        pcapFileName: "{{ pcap_file_name }}"
        domainUUID: "{{ domain_uuid }}"

```