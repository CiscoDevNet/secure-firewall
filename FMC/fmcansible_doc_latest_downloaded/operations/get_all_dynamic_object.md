# getAllDynamicObject

The getAllDynamicObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dynamicobjects](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dynamicobjects.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Dynamic Object associated with the specified ID. If no ID is specified for a GET, retrieves list of all Dynamic Objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| name | False | string <td colspan=3> If parameter is specified, only the Dynamic Objects matching with the specified name will be displayed. Cannot be used if object ID is specified in path. |
| includeCount | False | string <td colspan=3> If parameter is specified, mappingsCount field will be added into metadata. Can be used if object ID is specified in path. |
| filter | False | string <td colspan=3> Specify filter criteria<ul><li>Object with ids: <code>"ids:id1,id2,..."</code></li><li>Unused objects: <code>"unusedOnly:true"</code></li><li>Name starts with: <code>"nameStartsWith:{name-pattern}"</code></li></ul> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllDynamicObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllDynamicObject"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        name: "{{ name }}"
        includeCount: "{{ include_count }}"
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```