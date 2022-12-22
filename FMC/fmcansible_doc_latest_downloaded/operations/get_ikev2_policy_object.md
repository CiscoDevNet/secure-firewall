# getIkev2PolicyObject

The getIkev2PolicyObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ikev2policies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ikev2policies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKEv2 object associated with the specified ID. If no ID is specified for a GET, retrieves list of all IKEv2 monitor objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for IKEv2 monitor object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getIkev2PolicyObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getIkev2PolicyObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```