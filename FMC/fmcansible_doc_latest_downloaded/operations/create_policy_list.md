# createPolicyList

The createPolicyList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/policylists](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/policylists.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the PolicyList object associated with the specified ID. If no ID is specified for a GET, retrieves list of all PolicyList objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| interfaces | [{'name': 'secZone', 'id': 'security-zone-uuid', 'type': 'SecurityZone'}] |
| interfaceNames | ['inside'] |
| extendedCommunityLists | [{'name': 'ext_com_1', 'id': 'ext_com_uuid', 'type': 'ExtendedCommunityList'}] |
| tag | 2211 |
| matchCommunityExactly | False |
| metric | 111 |
| name | GlobalPL123 |
| action | DENY |
| overridable | False |
| description |   |
| type | PolicyList |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createPolicyList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createPolicyList"
    data:
        interfaces: [{'name': 'secZone', 'id': 'security-zone-uuid', 'type': 'SecurityZone'}]
        interfaceNames: ['inside']
        extendedCommunityLists: [{'name': 'ext_com_1', 'id': 'ext_com_uuid', 'type': 'ExtendedCommunityList'}]
        tag: 2211
        matchCommunityExactly: False
        metric: 111
        name: "GlobalPL123"
        action: "DENY"
        overridable: False
        description: " "
        type: "PolicyList"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```