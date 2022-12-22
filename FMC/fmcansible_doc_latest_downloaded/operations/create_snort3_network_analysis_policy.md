# createSnort3NetworkAnalysisPolicy

The createSnort3NetworkAnalysisPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/networkanalysispolicies](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/networkanalysispolicies.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the network analysis policy associated with the specified ID. Also, retrieves list of all network analysis policies. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | test1 |
| type | NetworkAnalysisPolicy |
| inlineDrop | 0 |
| basePolicy | {'id': 'networkAnalysisPolicyUUID', 'type': 'NetworkAnalysisPolicy'} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createSnort3NetworkAnalysisPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createSnort3NetworkAnalysisPolicy"
    data:
        name: "test1"
        type: "NetworkAnalysisPolicy"
        inlineDrop: 0
        basePolicy: {'id': 'networkAnalysisPolicyUUID', 'type': 'NetworkAnalysisPolicy'}
    path_params:
        domainUUID: "{{ domain_uuid }}"

```