# getAllSnort3IPSRulesObject

The getAllSnort3IPSRulesObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrules.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies Snort 3 intrusion rule associated with the specified ID. If no ID is specified for a GET, retrieves list of all Snort 3 intrusion rules.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Value can be any of the formats (including quotes): <code>"gid:123;sid:456"</code> or <code>"overrides:true;ipspolicy:{uuid1,uuid2,...}</code> or <code>"fts:789"</code> or <code>"isSystemDefined:{true/false}"</code>. <code>ipspolicy</code> is a comma-separated list of Snort 3 Intrusion Policy IDs. |
| sort | False | string <td colspan=3> Sorting parameters to be provided e.g. sid,-sid,gid,-gid,msg,-msg. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllSnort3IPSRulesObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllSnort3IPSRulesObject"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        sort: "{{ sort }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```