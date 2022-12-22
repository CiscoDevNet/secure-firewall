# createMultipleURLObject

The createMultipleURLObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/urls](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/urls.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the url objects associated with the specified ID. If no ID is specified, retrieves list of all url objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | Url |
| name | UrlObject1 |
| description | url object 1 |
| url | http://wwwin.cisco.com |
| type | Url |
| name | UrlObject2 |
| description | url object 2 |
| url | http://www.google.com |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for url objects. |

## Example
```yaml
- name: Execute 'createMultipleURLObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleURLObject"
    data:
        type: "Url"
        name: "UrlObject1"
        description: "url object 1"
        url: "http://wwwin.cisco.com"
        type: "Url"
        name: "UrlObject2"
        description: "url object 2"
        url: "http://www.google.com"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```