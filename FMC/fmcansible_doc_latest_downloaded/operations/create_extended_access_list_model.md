# createExtendedAccessListModel

The createExtendedAccessListModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/extendedaccesslists](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/extendedaccesslists.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Extended Access List associated with the specified ID. If no ID is specified, retrieves list of all Extended Access List. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | ExtendedAccessListTest |
| entries | [{'logLevel': 'ERROR', 'action': 'PERMIT', 'logging': 'PER_ACCESS_LIST_ENTRY', 'logInterval': 545, 'sourcePorts': {'objects': [{'id': '1834c674-38bb-11e2-86aa-62f0c593a59a'}], 'literals': [{'type': 'PortLiteral', 'port': '1521', 'protocol': '17'}, {'type': 'PortLiteral', 'port': '12314', 'protocol': '6'}]}, 'sourceNetworks': {'literals': [{'type': 'Host', 'value': '1.1.1.1'}, {'type': 'Host', 'value': '1.1.1.1/23'}, {'type': 'Network', 'value': 'fe80::abcd/123'}], 'objects': [{'id': '00000000-0000-0ed3-0000-257698037879'}, {'id': 'dde11d62-288b-4b4c-92e0-1dad0496f14b'}]}, 'destinationNetworks': {'objects': [{'id': '00000000-0000-0ed3-0000-270582939747'}, {'id': '192c14f2-39d9-409d-81e9-357793bdf1ec'}]}}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createExtendedAccessListModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createExtendedAccessListModel"
    data:
        name: "ExtendedAccessListTest"
        entries: [{'logLevel': 'ERROR', 'action': 'PERMIT', 'logging': 'PER_ACCESS_LIST_ENTRY', 'logInterval': 545, 'sourcePorts': {'objects': [{'id': '1834c674-38bb-11e2-86aa-62f0c593a59a'}], 'literals': [{'type': 'PortLiteral', 'port': '1521', 'protocol': '17'}, {'type': 'PortLiteral', 'port': '12314', 'protocol': '6'}]}, 'sourceNetworks': {'literals': [{'type': 'Host', 'value': '1.1.1.1'}, {'type': 'Host', 'value': '1.1.1.1/23'}, {'type': 'Network', 'value': 'fe80::abcd/123'}], 'objects': [{'id': '00000000-0000-0ed3-0000-257698037879'}, {'id': 'dde11d62-288b-4b4c-92e0-1dad0496f14b'}]}, 'destinationNetworks': {'objects': [{'id': '00000000-0000-0ed3-0000-270582939747'}, {'id': '192c14f2-39d9-409d-81e9-357793bdf1ec'}]}}]
    path_params:
        domainUUID: "{{ domain_uuid }}"

```