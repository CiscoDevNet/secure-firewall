# getAnyConnectProfileModel

The getAnyConnectProfileModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/anyconnectprofiles/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/anyconnectprofiles/{object_id}.md) path.&nbsp;
## Description
**Retrieves the AnyConnect Profile associated with the specified ID. If no ID is specified for a GET, retrieves list of all AnyConnect Profile objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for AnyConnect Profile object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getAnyConnectProfileModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAnyConnectProfileModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```