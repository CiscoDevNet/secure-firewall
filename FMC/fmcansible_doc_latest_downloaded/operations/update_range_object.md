# updateRangeObject

The updateRangeObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ranges/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ranges/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the address range object associated with the specified ID. If no ID is specified for a GET, retrieves list of all address range objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | TestRange2 |
| value | 2003::3-2003::4 |
| type | Range |
| description | Test Description |
| id | Range-obj-UUID-1 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for address range. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateRangeObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateRangeObject"
    data:
        name: "TestRange2"
        value: "2003::3-2003::4"
        type: "Range"
        description: "Test Description"
        id: "Range-obj-UUID-1"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```