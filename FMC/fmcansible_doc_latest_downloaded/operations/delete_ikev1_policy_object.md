# deleteIkev1PolicyObject

The deleteIkev1PolicyObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ikev1policies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ikev1policies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKEv1 policy object associated with the specified ID. If no ID is specified for a GET, retrieves list of all IKEv1 policy objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for IKEv1 policy object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteIkev1PolicyObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteIkev1PolicyObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```