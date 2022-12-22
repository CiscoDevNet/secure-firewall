# createAsPathList

The createAsPathList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/aspathlists](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/aspathlists.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the AsPath List associated with the specified ID. If no ID is specified, retrieves list of all AsPath Lists. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| entries | [{'sequence': 1, 'action': 'PERMIT', 'regularExpression': '-10+50*8'}] |
| name | 300 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createAsPathList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createAsPathList"
    data:
        entries: [{'sequence': 1, 'action': 'PERMIT', 'regularExpression': '-10+50*8'}]
        name: 300
    path_params:
        domainUUID: "{{ domain_uuid }}"

```