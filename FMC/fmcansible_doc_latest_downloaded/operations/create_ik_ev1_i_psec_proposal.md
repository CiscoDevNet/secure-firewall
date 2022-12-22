# createIKEv1IPsecProposal

The createIKEv1IPsecProposal operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ikev1ipsecproposals](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ikev1ipsecproposals.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKEv1 IPSec Proposal associated with the specified ID. If no ID is specified for a GET, retrieves list of all IKEv1 IPSec Proposal objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | ikev1ipsecproposal-test-1 |
| id | ikev1ipsecproposalUUID |
| espEncryption | DES |
| espHash | MD5 |
| description | IKEv1 IPsec object description |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createIKEv1IPsecProposal' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createIKEv1IPsecProposal"
    data:
        name: "ikev1ipsecproposal-test-1"
        id: "ikev1ipsecproposalUUID"
        espEncryption: "DES"
        espHash: "MD5"
        description: "IKEv1 IPsec object description"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```