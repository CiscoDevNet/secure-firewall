# getAllRealm

The getAllRealm operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/realms](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/realms.md) path.&nbsp;
## Description
**Retrieves the realm object associated with the specified ID. If no ID is specified, retrieves list of all realm objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Filter criteria can be specified using the format <code>name:name;realmType:realmType;enabled:enabled</code><br/><br/><code>name</code> -- Name of the realm to be queried. May start with ^ to indicate filtering by names starting with, rather than containing.<br/><code>realmType</code> -- Type of the realm to be queried. A comma seperated list of realm types.<br/><code>enabled</code> -- Either <code>true</code> or <code>false</code>.<br/> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllRealm' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllRealm"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```