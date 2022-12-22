# getSecurityZoneObject

The getSecurityZoneObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/securityzones/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/securityzones/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the security zone objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all security zone objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| groupByDevice | False | string <td colspan=3> Set true to group interfaces by device and return as <code>devices</code> attribute, instead of <code>interfaces</code>. |

## Example
```yaml
- name: Execute 'getSecurityZoneObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSecurityZoneObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        groupByDevice: "{{ group_by_device }}"

```