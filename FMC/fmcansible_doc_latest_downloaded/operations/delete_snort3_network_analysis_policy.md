# deleteSnort3NetworkAnalysisPolicy

The deleteSnort3NetworkAnalysisPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/networkanalysispolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/networkanalysispolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the network analysis policy associated with the specified ID. Also, retrieves list of all network analysis policies. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the network analysis policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteSnort3NetworkAnalysisPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteSnort3NetworkAnalysisPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```