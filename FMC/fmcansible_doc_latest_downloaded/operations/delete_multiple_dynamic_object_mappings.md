# deleteMultipleDynamicObjectMappings

The deleteMultipleDynamicObjectMappings operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dynamicobjects/{objectId}/mappings](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dynamicobjects/{object_id}/mappings.md) path.&nbsp;
## Description
**Retrieves, adds, or removes the Dynamic Object Mappings associated with the specified ID. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | True | string <td colspan=3> Specify filter criteria<ul><li>Object with ids: <code>"ids:id1,id2,..."</code></li><li>Unused objects: <code>"unusedOnly:true"</code></li><li>Name starts with: <code>"nameStartsWith:{name-pattern}"</code></li><li>Agent ID: <code>"agentId:{Agent ID}"</code></li></ul> |
| bulk | True | boolean <td colspan=3> Enables bulk removal of mappings |
| propagate | False | string <td colspan=3> Control propagating dynamic object mappings. It can be ["true", "false"]. Default value is "true". |

## Example
```yaml
- name: Execute 'deleteMultipleDynamicObjectMappings' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteMultipleDynamicObjectMappings"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        bulk: "{{ bulk }}"
        propagate: "{{ propagate }}"

```