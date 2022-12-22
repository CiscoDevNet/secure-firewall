# deleteMultipleSnort3IPSRulesObject

The deleteMultipleSnort3IPSRulesObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrules.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies Snort 3 intrusion rule associated with the specified ID. If no ID is specified for a GET, retrieves list of all Snort 3 intrusion rules. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | True | boolean <td colspan=3> This parameter specifies that bulk operation is being used in the query. This parameter is required for bulk Snort 3 intrusion rule operations. |
| filter | True | string <td colspan=3> Value can be any of the formats (including quotes): <code>"gid:123;sid:456"</code> or <code>"overrides:true;ipspolicy:{uuid1,uuid2,...}</code> or <code>"fts:789"</code> or <code>"isSystemDefined:{true/false}"</code>. <code>ipspolicy</code> is a comma-separated list of Snort 3 Intrusion Policy IDs. |

## Example
```yaml
- name: Execute 'deleteMultipleSnort3IPSRulesObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteMultipleSnort3IPSRulesObject"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"
        filter: "{{ filter }}"

```