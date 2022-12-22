# createMultipleSLAMonitorObjectModel

The createMultipleSLAMonitorObjectModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/slamonitors](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/slamonitors.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the sla monitor object associated with the specified ID. If no ID is specified for a GET, retrieves list of all sla monitor objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| interfaceNames | ['comment : interfaceNames are not allowed in POST. New Inline Interface Names can not be added via POST.'] |
| timeout | 5000 |
| type | SLAMonitor |
| threshold | 2 |
| frequency | 60 |
| slaId | 1 |
| dataSize | 28 |
| tos | 1 |
| noOfPackets | 1 |
| monitorAddress | 1.1.1.1 |
| interfaceObjects | [{'name': 'SecZone1', 'id': 'securityZoneUUID', 'type': 'SecurityZone'}, {'name': 'InterfaceGroup1', 'id': 'interfaceGroupUUID', 'type': 'InterfaceGroup'}] |
| description | Sla monitor description |
| name | SLA1 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for SLA monitor objects. |

## Example
```yaml
- name: Execute 'createMultipleSLAMonitorObjectModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleSLAMonitorObjectModel"
    data:
        interfaceNames: ['comment : interfaceNames are not allowed in POST. New Inline Interface Names can not be added via POST.']
        timeout: 5000
        type: "SLAMonitor"
        threshold: 2
        frequency: 60
        slaId: 1
        dataSize: 28
        tos: 1
        noOfPackets: 1
        monitorAddress: "1.1.1.1"
        interfaceObjects: [{'name': 'SecZone1', 'id': 'securityZoneUUID', 'type': 'SecurityZone'}, {'name': 'InterfaceGroup1', 'id': 'interfaceGroupUUID', 'type': 'InterfaceGroup'}]
        description: "Sla monitor description"
        name: "SLA1"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```