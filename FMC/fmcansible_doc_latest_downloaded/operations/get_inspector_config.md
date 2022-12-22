# getInspectorConfig

The getInspectorConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/networkanalysispolicies/{containerUUID}/inspectorconfigs](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/networkanalysispolicies/{container_uuid}/inspectorconfigs.md) path.&nbsp;
## Description
**Retrieves the inspector configuration associated with specified network analysis policy. The effective behaviour of the inspector configuration can be modified by modifying the inspector override configuration for the specified policy.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| inspectors | False | string <td colspan=3> Retrieves only the specified inspectors of the specified network analysis policy. Input is a comma-separated list of inspector names. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getInspectorConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getInspectorConfig"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        inspectors: "{{ inspectors }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```