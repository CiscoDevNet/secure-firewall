# createRealm

The createRealm operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/realms](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/realms.md) path.&nbsp;
## Description
**Retrieves the realm object associated with the specified ID. If no ID is specified, retrieves list of all realm objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createRealm' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createRealm"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```