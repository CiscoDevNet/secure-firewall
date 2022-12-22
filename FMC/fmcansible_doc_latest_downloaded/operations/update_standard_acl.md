# updateStandardACL

The updateStandardACL operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/standardaccesslists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/standardaccesslists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Standard Access List associated with the specified ID. If no ID is specified, retrieves list of all Standard Access List. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | stdACLObjectUUID |
| name | StandardAccessListTest |
| entries | [{'action': 'DENY', 'networks': {'objects': [{'id': '00000000-0000-0ed3-0000-270582939747'}]}}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a Standard Access List object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateStandardACL' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateStandardACL"
    data:
        id: "stdACLObjectUUID"
        name: "StandardAccessListTest"
        entries: [{'action': 'DENY', 'networks': {'objects': [{'id': '00000000-0000-0ed3-0000-270582939747'}]}}]
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```