# createIntrusionPolicy

The createIntrusionPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/intrusionpolicies](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/intrusionpolicies.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the intrusion policy associated with the specified ID. Also, retrieves list of all intrusion policies. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| basePolicy | {'name': 'test1', 'id': 'intrusionPolicyUUID', 'type': 'IntrusionPolicy'} |
| description | Created via automation |
| inspectionMode | PREVENTION |
| name | test1 |
| type | IntrusionPolicy |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createIntrusionPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createIntrusionPolicy"
    data:
        basePolicy: {'name': 'test1', 'id': 'intrusionPolicyUUID', 'type': 'IntrusionPolicy'}
        description: "Created via automation"
        inspectionMode: "PREVENTION"
        name: "test1"
        type: "IntrusionPolicy"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```