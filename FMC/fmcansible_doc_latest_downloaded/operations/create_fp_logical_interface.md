# createFPLogicalInterface

The createFPLogicalInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/fplogicalinterfaces](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/fplogicalinterfaces.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the logical interface associated with the specified NGIPS device ID and interface ID. If no ID is specified, retrieves list of all logical interfaces associated with the specified NGIPS device ID. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createFPLogicalInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createFPLogicalInterface"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```