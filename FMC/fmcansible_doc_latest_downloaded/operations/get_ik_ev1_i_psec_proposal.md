# getIKEv1IPsecProposal

The getIKEv1IPsecProposal operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ikev1ipsecproposals/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ikev1ipsecproposals/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKEv1 IPSec Proposal associated with the specified ID. If no ID is specified for a GET, retrieves list of all IKEv1 IPSec Proposal objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for IKEv1 IPSec Proposal object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getIKEv1IPsecProposal' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getIKEv1IPsecProposal"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```