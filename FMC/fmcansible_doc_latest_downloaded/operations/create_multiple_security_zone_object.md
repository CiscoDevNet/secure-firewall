# createMultipleSecurityZoneObject

The createMultipleSecurityZoneObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/securityzones](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/securityzones.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the security zone objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all security zone objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | SecurityZone |
| name | SecurityZoneObject5 |
| interfaceMode | INLINE |
| interfaces | [{'type': 'PhysicalInterface', 'id': 'Intf-UUID-1', 'name': 'eth1'}, {'type': 'PhysicalInterface', 'id': 'Intf-UUID-2', 'name': 'eth2'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for security zone objects. |

## Example
```yaml
- name: Execute 'createMultipleSecurityZoneObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleSecurityZoneObject"
    data:
        type: "SecurityZone"
        name: "SecurityZoneObject5"
        interfaceMode: "INLINE"
        interfaces: [{'type': 'PhysicalInterface', 'id': 'Intf-UUID-1', 'name': 'eth1'}, {'type': 'PhysicalInterface', 'id': 'Intf-UUID-2', 'name': 'eth2'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```