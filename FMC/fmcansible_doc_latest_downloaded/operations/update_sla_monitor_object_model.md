# updateSLAMonitorObjectModel

The updateSLAMonitorObjectModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/slamonitors/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/slamonitors/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the sla monitor object associated with the specified ID. If no ID is specified for a GET, retrieves list of all sla monitor objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| interfaceNames | ['Interface1', 'comment : For interfaceNames the only option in PUT is to remove these, no new additions of inline interface names will be allowed.'] |
| timeout | 5000 |
| type | SLAMonitor |
| threshold | 2 |
| frequency | 60 |
| slaId | 1 |
| dataSize | 28 |
| tos | 1 |
| noOfPackets | 1 |
| monitorAddress | 1.1.1.2 |
| interfaceObjects | [{'name': 'SecZone1', 'id': 'securityZoneUUID', 'type': 'SecurityZone'}, {'name': 'InterfaceGroup1', 'id': 'interfaceGroupUUID', 'type': 'InterfaceGroup'}] |
| description | Sla monitor description updated |
| name | SLA1-Updated |
| id | slaMonitorObjectUUID |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for sla monitor object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateSLAMonitorObjectModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateSLAMonitorObjectModel"
    data:
        interfaceNames: ['Interface1', 'comment : For interfaceNames the only option in PUT is to remove these, no new additions of inline interface names will be allowed.']
        timeout: 5000
        type: "SLAMonitor"
        threshold: 2
        frequency: 60
        slaId: 1
        dataSize: 28
        tos: 1
        noOfPackets: 1
        monitorAddress: "1.1.1.2"
        interfaceObjects: [{'name': 'SecZone1', 'id': 'securityZoneUUID', 'type': 'SecurityZone'}, {'name': 'InterfaceGroup1', 'id': 'interfaceGroupUUID', 'type': 'InterfaceGroup'}]
        description: "Sla monitor description updated"
        name: "SLA1-Updated"
        id: "slaMonitorObjectUUID"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```