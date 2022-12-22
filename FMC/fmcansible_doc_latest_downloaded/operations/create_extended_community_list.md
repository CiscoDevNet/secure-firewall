# createExtendedCommunityList

The createExtendedCommunityList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/extendedcommunitylists](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/extendedcommunitylists.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the ExtendedCommunityList object associated with the specified ID. If no ID is specified for a GET, retrieves list of all ExtendedCommunityList objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | ExtendedCommunityList |
| name | string |
| subType | Expanded|Standard |
| entries | [{'sequence': 'integer', 'action': 'PERMIT|DENY', 'routeTarget|regularExpression': 'string'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createExtendedCommunityList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createExtendedCommunityList"
    data:
        type: "ExtendedCommunityList"
        name: "string"
        subType: "Expanded|Standard"
        entries: [{'sequence': 'integer', 'action': 'PERMIT|DENY', 'routeTarget|regularExpression': 'string'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"

```