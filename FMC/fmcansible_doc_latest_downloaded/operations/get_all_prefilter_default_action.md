# getAllPrefilterDefaultAction

The getAllPrefilterDefaultAction operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies/{containerUUID}/defaultactions](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies/{container_uuid}/defaultactions.md) path.&nbsp;
## Description
**Retrieves or modifies the default action associated with the specified prefilter control policy ID and default action ID. If no default action ID is specified, retrieves list of all default actions associated with the specified prefilter policy ID.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllPrefilterDefaultAction' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllPrefilterDefaultAction"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```