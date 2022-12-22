# getDeployableDevice

The getDeployableDevice operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deployment/deployabledevices](/paths//api/fmc_config/v1/domain/{domain_uuid}/deployment/deployabledevices.md) path.&nbsp;
## Description
**Retrieves list of all devices with configuration changes, ready to be deployed.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| groupDependency | False | string <td colspan=3> Group Dependency of the dirty policies. Allowed values are <code>true</code> or <code>false</code>. Group dependency value helps to add dependent policies in Selective Policy Deployment. Results will be shown only when expanded is set to true. It may affect the performance of the API. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getDeployableDevice' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDeployableDevice"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        groupDependency: "{{ group_dependency }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```