# updateFPPhysicalInterface

The updateFPPhysicalInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/fpphysicalinterfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/fpphysicalinterfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the physical interface associated with the specified NGIPS device ID and interface ID. If no ID is specified, retrieves list of all physical interfaces associated with the specified NGIPS device ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | s1p4 |
| type | FPPhysicalInterface |
| id | fpphysicalinterfaceUUID2 |
| enabled | 1 |
| interfaceType | INLINE |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a physical interface. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateFPPhysicalInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateFPPhysicalInterface"
    data:
        name: "s1p4"
        type: "FPPhysicalInterface"
        id: "fpphysicalinterfaceUUID2"
        enabled: 1
        interfaceType: "INLINE"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```