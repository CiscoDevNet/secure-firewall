# updateSecurityZoneObject

The updateSecurityZoneObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/securityzones/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/securityzones/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the security zone objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all security zone objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | SecurityZone |
| name | SecurityZoneObject5 |
| id | Sec-zone-UUID-1 |
| interfaceMode | INLINE |
| interfaces | [{'type': 'FPPhysicalInterface', 'id': 'Intf-UUID-1', 'name': 'eth1'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateSecurityZoneObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateSecurityZoneObject"
    data:
        type: "SecurityZone"
        name: "SecurityZoneObject5"
        id: "Sec-zone-UUID-1"
        interfaceMode: "INLINE"
        interfaces: [{'type': 'FPPhysicalInterface', 'id': 'Intf-UUID-1', 'name': 'eth1'}]
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```