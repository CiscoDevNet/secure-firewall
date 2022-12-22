# getAnyConnectExternalBrowserPackageModel

The getAnyConnectExternalBrowserPackageModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/anyconnectexternalbrowserpackages/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/anyconnectexternalbrowserpackages/{object_id}.md) path.&nbsp;
## Description
**Retrieves the AnyConnect External Browser Package associated with the specified ID. If no ID is specified for a GET, retrieves list of all AnyConnect External Browser Package objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for AnyConnect External Browser Package object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getAnyConnectExternalBrowserPackageModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAnyConnectExternalBrowserPackageModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```