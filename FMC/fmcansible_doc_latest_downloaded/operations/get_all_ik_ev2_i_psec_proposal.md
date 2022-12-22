# getAllIKEv2IPsecProposal

The getAllIKEv2IPsecProposal operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ikev2ipsecproposals](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ikev2ipsecproposals.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKEv2 IPSec Proposal associated with the specified ID. If no ID is specified for a GET, retrieves list of all IKEv2 IPSec Proposal objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllIKEv2IPsecProposal' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllIKEv2IPsecProposal"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```