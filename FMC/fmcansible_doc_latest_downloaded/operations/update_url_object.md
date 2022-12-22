# updateURLObject

The updateURLObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/urls/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/urls/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the url objects associated with the specified ID. If no ID is specified, retrieves list of all url objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | Url |
| url | www.cisco.com |
| overridable | True |
| overrides | {'parent': {'id': 'url1_uuid', 'type': 'Url'}, 'target': {'name': '10.10.16.29', 'id': 'target_uuid', 'type': 'Device'}} |
| description |   |
| id | url1_uuid |
| name | url1 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateURLObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateURLObject"
    data:
        type: "Url"
        url: "www.cisco.com"
        overridable: True
        overrides: {'parent': {'id': 'url1_uuid', 'type': 'Url'}, 'target': {'name': '10.10.16.29', 'id': 'target_uuid', 'type': 'Device'}}
        description: " "
        id: "url1_uuid"
        name: "url1"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```