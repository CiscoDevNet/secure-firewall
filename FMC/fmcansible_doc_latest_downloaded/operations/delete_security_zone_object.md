# deleteSecurityZoneObject

The deleteSecurityZoneObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/securityzones/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/securityzones/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the security zone objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all security zone objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteSecurityZoneObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteSecurityZoneObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```