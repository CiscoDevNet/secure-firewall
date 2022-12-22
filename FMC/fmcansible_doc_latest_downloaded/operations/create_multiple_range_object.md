# createMultipleRangeObject

The createMultipleRangeObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ranges](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ranges.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the address range object associated with the specified ID. If no ID is specified for a GET, retrieves list of all address range objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | TestRange2 |
| value | 10.4.30.40-10.4.30.50 |
| type | Range |
| description | Test Description |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for range objects. |

## Example
```yaml
- name: Execute 'createMultipleRangeObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleRangeObject"
    data:
        name: "TestRange2"
        value: "10.4.30.40-10.4.30.50"
        type: "Range"
        description: "Test Description"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```