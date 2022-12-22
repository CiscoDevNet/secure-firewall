# getPacketTracerPCAPExtract

The getPacketTracerPCAPExtract operation handles configuration related to [/api/fmc_troubleshoot/v1/domain/{domainUUID}/packettracer/files/{pcapFileName}/details](/paths//api/fmc_troubleshoot/v1/domain/{domain_uuid}/packettracer/files/{pcap_file_name}/details.md) path.&nbsp;
## Description
**Retrieves the packet details from a PCAP file.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| pcapFileName | True | string <td colspan=3> The PCAP File Name under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getPacketTracerPCAPExtract' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getPacketTracerPCAPExtract"
    path_params:
        pcapFileName: "{{ pcap_file_name }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```