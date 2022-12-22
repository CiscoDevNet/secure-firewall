# deleteIKEv2IPsecProposal

The deleteIKEv2IPsecProposal operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ikev2ipsecproposals/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ikev2ipsecproposals/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKEv2 IPSec Proposal associated with the specified ID. If no ID is specified for a GET, retrieves list of all IKEv2 IPSec Proposal objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for IKEv2 IPSec Proposal object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteIKEv2IPsecProposal' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteIKEv2IPsecProposal"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```