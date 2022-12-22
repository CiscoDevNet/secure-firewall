# getAllDNSServerGroupObject

The getAllDNSServerGroupObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dnsservergroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dnsservergroups.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the DNS Server Group object associated with the specified ID. If no ID is specified for a GET, retrieves list of all DNS Server Group objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the object on given target ID. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllDNSServerGroupObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllDNSServerGroupObject"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```