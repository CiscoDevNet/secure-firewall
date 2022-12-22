# createStandardACL

The createStandardACL operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/standardaccesslists](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/standardaccesslists.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Standard Access List associated with the specified ID. If no ID is specified, retrieves list of all Standard Access List. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | StandardAccessListTest |
| entries | [{'action': 'PERMIT', 'networks': {'literals': [{'type': 'Host', 'value': '1.1.1.1'}], 'objects': [{'id': '00000000-0000-0ed3-0000-270582939747'}]}}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createStandardACL' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createStandardACL"
    data:
        name: "StandardAccessListTest"
        entries: [{'action': 'PERMIT', 'networks': {'literals': [{'type': 'Host', 'value': '1.1.1.1'}], 'objects': [{'id': '00000000-0000-0ed3-0000-270582939747'}]}}]
    path_params:
        domainUUID: "{{ domain_uuid }}"

```