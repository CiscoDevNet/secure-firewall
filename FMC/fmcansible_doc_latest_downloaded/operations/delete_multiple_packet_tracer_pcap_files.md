# deleteMultiplePacketTracerPCAPFiles

The deleteMultiplePacketTracerPCAPFiles operation handles configuration related to [/api/fmc_troubleshoot/v1/domain/{domainUUID}/packettracer/files](/paths//api/fmc_troubleshoot/v1/domain/{domain_uuid}/packettracer/files.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves PCAP files from FMC. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | True | boolean <td colspan=3> Enables bulk delete for PCAP files. |
| filter | True | string <td colspan=3> To be used in conjunction with <code>bulk=true</code> for bulk deletion. Various filter criteria can be specified using the format:<br><code>pcapFileNames:file1,file2,file3...</code> will delete only the PCAP files provided in the list.<br><code>deleteAllFiles:true</code> will delete all the PCAP files. |

## Example
```yaml
- name: Execute 'deleteMultiplePacketTracerPCAPFiles' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteMultiplePacketTracerPCAPFiles"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"
        filter: "{{ filter }}"

```