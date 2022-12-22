# getFTDManualNatRule

The getFTDManualNatRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftdnatpolicies/{containerUUID}/manualnatrules/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftdnatpolicies/{container_uuid}/manualnatrules/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Manual NAT rule associated with the specified ID. Also, retrieves list of all Manual NAT rules.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a Manual NAT rule. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| section | False | string <td colspan=3> Retrieves, creates or modifies manual nat rule in given section. Allowed value is 'before_auto' and 'after_auto'. |

## Example
```yaml
- name: Execute 'getFTDManualNatRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getFTDManualNatRule"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        section: "{{ section }}"

```