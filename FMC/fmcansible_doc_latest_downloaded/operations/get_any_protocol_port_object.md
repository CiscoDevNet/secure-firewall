# getAnyProtocolPortObject

The getAnyProtocolPortObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/anyprotocolportobjects/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/anyprotocolportobjects/{object_id}.md) path.&nbsp;
## Description
**Retrieves any protocol port object associated with the specified ID. If no ID is specified for a GET, retrieves list of all any protocol port objects (all port objects with a protocol value of All).**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getAnyProtocolPortObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAnyProtocolPortObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```