# getAllSIDNSFeed

The getAllSIDNSFeed operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/sidnsfeeds](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/sidnsfeeds.md) path.&nbsp;
## Description
**Retrieves the Security Intelligence DNS feed objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all Security Intelligence DNS feed objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllSIDNSFeed' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllSIDNSFeed"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```