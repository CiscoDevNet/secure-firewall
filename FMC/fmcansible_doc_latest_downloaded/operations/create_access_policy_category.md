# createAccessPolicyCategory

The createAccessPolicyCategory operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{containerUUID}/categories](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{container_uuid}/categories.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the category associated with the specified policy ID. If no ID is specified, retrieves list of all categories associated with the specified policy ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | Category |
| name | Category0001 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| section | False | string <td colspan=3> Retrieves, creates or modifies category in given section. Allowed value is 'mandatory' and 'default'. |
| aboveCategory | False | string <td colspan=3> creates category above specified category. |
| insertBefore | False | string <td colspan=3> creates category above given rule index. |
| insertAfter | False | string <td colspan=3> creates category below given rule index. |

## Example
```yaml
- name: Execute 'createAccessPolicyCategory' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createAccessPolicyCategory"
    data:
        type: "Category"
        name: "Category0001"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        section: "{{ section }}"
        aboveCategory: "{{ above_category }}"
        insertBefore: "{{ insert_before }}"
        insertAfter: "{{ insert_after }}"

```