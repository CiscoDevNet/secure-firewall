# deleteIkev2PolicyObject

The deleteIkev2PolicyObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ikev2policies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ikev2policies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKEv2 object associated with the specified ID. If no ID is specified for a GET, retrieves list of all IKEv2 monitor objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for IKEv2 monitor object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteIkev2PolicyObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteIkev2PolicyObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```