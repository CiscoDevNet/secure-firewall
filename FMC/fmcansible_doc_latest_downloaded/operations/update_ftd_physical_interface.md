# updateFTDPhysicalInterface

The updateFTDPhysicalInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/physicalinterfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/physicalinterfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves the physical interface associated with the specified NGFW device ID and interface ID. If no interface ID is specified, retrieves list of all physical interfaces associated with the specified NGFW device ID. <div class="alert alert-warning">More details on netmod events(out of sync interfaces):<b> GET /interfaceevents</b></div> _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | PhysicalInterface |
| enabled | False |
| MTU | 1500 |
| name | Ethernet1/16 |
| id | PhyIntfId |
| mode | NONE |
| hardware | {'speed': 'TWENTY_FIVE_THOUSAND', 'duplex': 'FULL', 'autoNegState': True, 'fecMode': 'CL108RS'} |
| managementOnly | False |
| enableSGTPropagate | False |
| ipv6 | {'enableIPV6': False} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a NGFW physical interface. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateFTDPhysicalInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateFTDPhysicalInterface"
    data:
        type: "PhysicalInterface"
        enabled: False
        MTU: 1500
        name: "Ethernet1/16"
        id: "PhyIntfId"
        mode: "NONE"
        hardware: {'speed': 'TWENTY_FIVE_THOUSAND', 'duplex': 'FULL', 'autoNegState': True, 'fecMode': 'CL108RS'}
        managementOnly: False
        enableSGTPropagate: False
        ipv6: {'enableIPV6': False}
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```