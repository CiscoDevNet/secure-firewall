# createFTDNatPolicy

The createFTDNatPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftdnatpolicies](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftdnatpolicies.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the NAT policy associated with the specified ID. Also, retrieves list of all NAT policies. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | FTDNatPolicy |
| name | NatPol5 |
| description | nat policy for testing rest api |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createFTDNatPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createFTDNatPolicy"
    data:
        type: "FTDNatPolicy"
        name: "NatPol5"
        description: "nat policy for testing rest api"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```