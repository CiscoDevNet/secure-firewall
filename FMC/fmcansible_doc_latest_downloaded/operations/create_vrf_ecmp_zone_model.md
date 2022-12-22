# createVrfECMPZoneModel

The createVrfECMPZoneModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/routing/virtualrouters/{virtualrouterUUID}/ecmpzones](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/routing/virtualrouters/{virtualrouter_uuid}/ecmpzones.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the ECMP Zone associated for the specified virtual router. Also, retrieves list of all ECMP Zone.  _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | ecmpzones |
| name | ECMPZoneBeta |
| description | ECMP Zone Beta |
| interfaces | [{'id': 'interface_uuid1', 'type': 'PhysicalInterface', 'name': 'GigabitEthernet1/1'}, {'id': 'interface_uuid2', 'type': 'PhysicalInterface', 'name': 'GigabitEthernet1/2'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| virtualrouterUUID | True | string <td colspan=3> Unique identifier of Virtual Router |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createVrfECMPZoneModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createVrfECMPZoneModel"
    data:
        type: "ecmpzones"
        name: "ECMPZoneBeta"
        description: "ECMP Zone Beta"
        interfaces: [{'id': 'interface_uuid1', 'type': 'PhysicalInterface', 'name': 'GigabitEthernet1/1'}, {'id': 'interface_uuid2', 'type': 'PhysicalInterface', 'name': 'GigabitEthernet1/2'}]
    path_params:
        virtualrouterUUID: "{{ virtualrouter_uuid }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```