# getAnyConnectCustomAttributeModel

The getAnyConnectCustomAttributeModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/anyconnectcustomattributes/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/anyconnectcustomattributes/{object_id}.md) path.&nbsp;
## Description
**Retrieves the AnyConnect Custom Attribute associated with the specified ID. If no ID is specified for a GET, retrieves list of all AnyConnect Custom Attribute objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for AnyConnect Custom Attribute object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getAnyConnectCustomAttributeModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAnyConnectCustomAttributeModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```