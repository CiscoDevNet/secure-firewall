# deleteAccessPolicy

The deleteAccessPolicy operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the access control policy associated with the specified ID. Also, retrieves list of all access control policies. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for access control policy. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| ignoreWarning | False | string <td colspan=3> Shows any warnings when deleting an access policy, if set to false. If not specified, value is set to true and warnings are ignored. Allowed values are 'true' and 'false'. |

## Example
```yaml
- name: Execute 'deleteAccessPolicy' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteAccessPolicy"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        ignoreWarning: "{{ ignore_warning }}"

```