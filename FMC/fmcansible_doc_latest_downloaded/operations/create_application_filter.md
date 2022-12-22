# createApplicationFilter

The createApplicationFilter operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/applicationfilters](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/applicationfilters.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the application filter object associated with the specified ID. If no ID is specified, retrieves list of all application filter objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createApplicationFilter' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createApplicationFilter"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```