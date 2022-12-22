# getAllInterfaceObject

The getAllInterfaceObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/interfaceobjects](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/interfaceobjects.md) path.&nbsp;
## Description
**Retrieves list of all the interface objects both security zones and interface groups.**

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
- name: Execute 'getAllInterfaceObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllInterfaceObject"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```