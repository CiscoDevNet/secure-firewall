# getAllPrefilterRule

The getAllPrefilterRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies/{containerUUID}/prefilterrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies/{container_uuid}/prefilterrules.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the prefilter rule associated with the specified policy ID and rule ID. If no ID is specified, retrieves list of all prefilter rules associated with the specified policy ID.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| ruleType | False | string <td colspan=3> If parameter is specified, only the policies with specified <code>ruleType</code> will be shown. Allowed values are 'PREFILTER' and 'TUNNEL'. Cannot be used if object ID is specified in path. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllPrefilterRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllPrefilterRule"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        ruleType: "{{ rule_type }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```