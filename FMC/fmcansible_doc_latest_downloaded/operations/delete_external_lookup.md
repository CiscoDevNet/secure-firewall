# deleteExternalLookup

The deleteExternalLookup operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/integration/externallookups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/integration/externallookups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the external lookup associated with the specified ID. If no ID is specified for a GET, retrieves list of all external lookups. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for an external lookup. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteExternalLookup' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteExternalLookup"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```