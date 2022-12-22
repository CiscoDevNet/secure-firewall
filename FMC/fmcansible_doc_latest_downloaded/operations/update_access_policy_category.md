# updateAccessPolicyCategory

The updateAccessPolicyCategory operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{containerUUID}/categories/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{container_uuid}/categories/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the category associated with the specified policy ID. If no ID is specified, retrieves list of all categories associated with the specified policy ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | id_of_category |
| type | Category |
| name | Category0001 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a category. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateAccessPolicyCategory' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateAccessPolicyCategory"
    data:
        id: "id_of_category"
        type: "Category"
        name: "Category0001"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```