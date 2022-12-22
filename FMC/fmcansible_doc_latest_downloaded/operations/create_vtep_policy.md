# createVTEPPolicy

The createVTEPPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/vteppolicies](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/vteppolicies.md) path.&nbsp;
## Description
**Retrieves the VTEP Policy associated with the specified NGFW device ID and policy ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| nveEnable | True |
| vtepEntries | [{'sourceInterface': {'name': 'GigabitEthernet0/0', 'type': 'PhysicalInterface', 'id': 'interfaceUUID'}, 'nveVtepId': 1, 'nveDestinationPort': 6081, 'nveEncapsulationType': 'GENEVE'}] |
| type | VTEPPolicy |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createVTEPPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createVTEPPolicy"
    data:
        nveEnable: True
        vtepEntries: [{'sourceInterface': {'name': 'GigabitEthernet0/0', 'type': 'PhysicalInterface', 'id': 'interfaceUUID'}, 'nveVtepId': 1, 'nveDestinationPort': 6081, 'nveEncapsulationType': 'GENEVE'}]
        type: "VTEPPolicy"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```