# updateSnort3NetworkAnalysisPolicy

The updateSnort3NetworkAnalysisPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/networkanalysispolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/networkanalysispolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the network analysis policy associated with the specified ID. Also, retrieves list of all network analysis policies. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | networkAnalysisPolicyUUID |
| name | test1_updated |
| type | NetworkAnalysisPolicy |
| inlineDrop | 1 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the network analysis policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| replicateInspectionMode | False | string <td colspan=3> Flag to replicate inspection mode from snort 3 version to snort 2 version. |

## Example
```yaml
- name: Execute 'updateSnort3NetworkAnalysisPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateSnort3NetworkAnalysisPolicy"
    data:
        id: "networkAnalysisPolicyUUID"
        name: "test1_updated"
        type: "NetworkAnalysisPolicy"
        inlineDrop: 1
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        replicateInspectionMode: "{{ replicate_inspection_mode }}"

```