# createExternalLookup

The createExternalLookup operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/integration/externallookups](/paths//api/fmc_config/v1/domain/{domain_uuid}/integration/externallookups.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the external lookup associated with the specified ID. If no ID is specified for a GET, retrieves list of all external lookups. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | test |
| template | http://www.example.com |
| enabled | True |
| type | ExternalLookup |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createExternalLookup' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createExternalLookup"
    data:
        name: "test"
        template: "http://www.example.com"
        enabled: True
        type: "ExternalLookup"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```