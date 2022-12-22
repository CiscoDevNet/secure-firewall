# getPolicyList

The getPolicyList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/policylists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/policylists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the PolicyList object associated with the specified ID. If no ID is specified for a GET, retrieves list of all PolicyList objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique Identifier of the Policy List |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getPolicyList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getPolicyList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```