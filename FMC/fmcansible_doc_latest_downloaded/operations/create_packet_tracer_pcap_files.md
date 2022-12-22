# createPacketTracerPCAPFiles

The createPacketTracerPCAPFiles operation handles configuration related to [/api/fmc_troubleshoot/v1/domain/{domainUUID}/packettracer/files](/paths//api/fmc_troubleshoot/v1/domain/{domain_uuid}/packettracer/files.md) path.&nbsp;
## Description
**Creates, deletes, or retrieves PCAP files from FMC. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| payloadFile | .pcap or .pcapng file |
| replaceFile | true or false |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createPacketTracerPCAPFiles' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createPacketTracerPCAPFiles"
    data:
        payloadFile: ".pcap or .pcapng file"
        replaceFile: "true or false"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```