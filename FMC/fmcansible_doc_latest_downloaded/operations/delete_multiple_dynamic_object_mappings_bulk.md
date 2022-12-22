# deleteMultipleDynamicObjectMappingsBulk

The deleteMultipleDynamicObjectMappingsBulk operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dynamicobjectmappings](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dynamicobjectmappings.md) path.&nbsp;
## Description
**Adds or removes Dynamic Object Mappings for specific Dynamic Objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Specify filter criteria<ul><li>Object with ids: <code>"ids:id1,id2,..."</code></li><li>Unused objects: <code>"unusedOnly:true"</code></li><li>Name starts with: <code>"nameStartsWith:{name-pattern}"</code></li><li>Agent ID: <code>"agentId:{Agent ID}"</code></li></ul> |
| bulk | True | boolean <td colspan=3> Enables bulk removal of mappings |
| propagate | False | string <td colspan=3> Control propagating dynamic object mappings. It can be ["true", "false"]. Default value is "true". |

## Example
```yaml
- name: Execute 'deleteMultipleDynamicObjectMappingsBulk' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteMultipleDynamicObjectMappingsBulk"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        bulk: "{{ bulk }}"
        propagate: "{{ propagate }}"

```