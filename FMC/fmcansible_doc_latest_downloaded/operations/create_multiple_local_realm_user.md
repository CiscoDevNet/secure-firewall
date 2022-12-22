# createMultipleLocalRealmUser

The createMultipleLocalRealmUser operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/localrealmusers](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/localrealmusers.md) path.&nbsp;
## Description
**Retrieves the local realm user object associated with the specified ID. If no ID is specified, retrieves list of all local realm user objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for Local Realm Users. |

## Example
```yaml
- name: Execute 'createMultipleLocalRealmUser' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleLocalRealmUser"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```