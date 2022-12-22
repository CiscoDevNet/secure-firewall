# createPrefilterPolicy

The createPrefilterPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies.md) path.&nbsp;
## Description
**Retrieves prefilter policy associated with the specified ID. Also, retrieves list of all prefilter policies. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | PrefilterPolicy |
| name | PrefilterPolicy1 |
| description | policy to test FMC implementation |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createPrefilterPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createPrefilterPolicy"
    data:
        type: "PrefilterPolicy"
        name: "PrefilterPolicy1"
        description: "policy to test FMC implementation"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```