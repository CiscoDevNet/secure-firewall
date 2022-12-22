# getAllRealmUser

The getAllRealmUser operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/realmusers](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/realmusers.md) path.&nbsp;
## Description
**Retrieves the realm user object associated with the specified ID. If no ID is specified, retrieves list of all realm user objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Filter criteria can be specified using the format <code>name:name;realm:realm;groupId:groupId;resolved:resolved</code><br/><br/><code>name</code> -- Name of the user to be queried starting with...<br/><code>realm</code> -- Realm uuid for the user.<br/><code>groupId</code> -- Users with the group id. <br/><code>resolved</code> -- Either <code>true</code> or <code>false</code>.<br/> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllRealmUser' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllRealmUser"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```