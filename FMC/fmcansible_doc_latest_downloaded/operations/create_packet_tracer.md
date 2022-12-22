# createPacketTracer

The createPacketTracer operation handles configuration related to [/api/fmc_troubleshoot/v1/domain/{domainUUID}/packettracer/traces](/paths//api/fmc_troubleshoot/v1/domain/{domain_uuid}/packettracer/traces.md) path.&nbsp;
## Description
**Retrieves the Packet Tracer command output for a FTD or Cluster. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| device | {'id': '005056B1-FFEF-0ed3-0000-004294968641', 'type': 'Device', 'name': 'Device_A'} |
| interface | {'id': '005056B1-FFEF-0ed3-0000-004294968640', 'type': 'PhysicalInterface', 'name': 'Management'} |
| protocol | TCP |
| sourceIPType | IPv4 |
| sourceIPValue | 192.168.0.138 |
| destinationIPType | IPv4 |
| destinationIPValue | 192.168.0.136 |
| sourcePort | 22 |
| destinationPort | 22 |
| inlineTag | 23 |
| icmpType | 123 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createPacketTracer' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createPacketTracer"
    data:
        device: {'id': '005056B1-FFEF-0ed3-0000-004294968641', 'type': 'Device', 'name': 'Device_A'}
        interface: {'id': '005056B1-FFEF-0ed3-0000-004294968640', 'type': 'PhysicalInterface', 'name': 'Management'}
        protocol: "TCP"
        sourceIPType: "IPv4"
        sourceIPValue: "192.168.0.138"
        destinationIPType: "IPv4"
        destinationIPValue: "192.168.0.136"
        sourcePort: "22"
        destinationPort: "22"
        inlineTag: 23
        icmpType: 123
    path_params:
        domainUUID: "{{ domain_uuid }}"

```