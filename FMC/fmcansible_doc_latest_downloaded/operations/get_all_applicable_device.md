# getAllApplicableDevice

The getAllApplicableDevice operation handles configuration related to [/api/fmc_platform/v1/updates/upgradepackages/{containerUUID}/applicabledevices](/paths//api/fmc_platform/v1/updates/upgradepackages/{container_uuid}/applicabledevices.md) path.&nbsp;
## Description
**Devices available for a particular upgrade package.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllApplicableDevice' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllApplicableDevice"
    path_params:
        containerUUID: "{{ container_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```