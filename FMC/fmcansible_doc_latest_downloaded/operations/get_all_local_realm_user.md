# getAllLocalRealmUser

The getAllLocalRealmUser operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/localrealmusers](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/localrealmusers.md) path.&nbsp;
## Description
**Retrieves the local realm user object associated with the specified ID. If no ID is specified, retrieves list of all local realm user objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> To filter users by realm, use <code>realm:{realmUUID}</code><br/><br/>To filter users by name, use <code>name:{name}</code> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllLocalRealmUser' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllLocalRealmUser"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```