# updateExtendedCommunityList

The updateExtendedCommunityList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/extendedcommunitylists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/extendedcommunitylists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the ExtendedCommunityList object associated with the specified ID. If no ID is specified for a GET, retrieves list of all ExtendedCommunityList objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| subType | Standard |
| type | ExtendedCommunityList |
| entries | [{'action': 'DENY', 'sequence': 123, 'routeTarget': '1:2'}] |
| name | EXT_COM_1 |
| id | ExtendedCommunityListUUID |
| overridable | False |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for ExtendedCommunityList object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateExtendedCommunityList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateExtendedCommunityList"
    data:
        subType: "Standard"
        type: "ExtendedCommunityList"
        entries: [{'action': 'DENY', 'sequence': 123, 'routeTarget': '1:2'}]
        name: "EXT_COM_1"
        id: "ExtendedCommunityListUUID"
        overridable: False
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```