# getEndPointDeviceType

The getEndPointDeviceType operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/endpointdevicetypes/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/endpointdevicetypes/{object_id}.md) path.&nbsp;
## Description
**Retrieves the endpoint device type object associated with the specified ID. If no ID is specified, retrieves list of all endpoint device type objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the endpoint device type object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getEndPointDeviceType' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getEndPointDeviceType"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```