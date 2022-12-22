# getInspectorOverrideConfig

The getInspectorOverrideConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/networkanalysispolicies/{containerUUID}/inspectoroverrideconfigs](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/networkanalysispolicies/{container_uuid}/inspectoroverrideconfigs.md) path.&nbsp;
## Description
**Retrieves or modifies the inspector override configuration associated with the specified policy. An inspector override allows the user to modify behaviour specified in the base policy's inspector configuration.**

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
- name: Execute 'getInspectorOverrideConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getInspectorOverrideConfig"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        inspectors: "{{ inspectors }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```