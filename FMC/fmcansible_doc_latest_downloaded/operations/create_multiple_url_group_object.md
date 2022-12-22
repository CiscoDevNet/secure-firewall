# createMultipleURLGroupObject

The createMultipleURLGroupObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/urlgroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/urlgroups.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the url group objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all url group objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | urlgroup_obj1 |
| objects | [{'type': 'Url', 'id': 'UrlObjectUUID'}] |
| literals | [{'type': 'Url', 'url': 'www.google.com'}] |
| type | UrlGroup |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for url group objects. |

## Example
```yaml
- name: Execute 'createMultipleURLGroupObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleURLGroupObject"
    data:
        name: "urlgroup_obj1"
        objects: [{'type': 'Url', 'id': 'UrlObjectUUID'}]
        literals: [{'type': 'Url', 'url': 'www.google.com'}]
        type: "UrlGroup"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```