# updateRESTSettings

The updateRESTSettings operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/settings/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/settings/{object_id}.md) path.&nbsp;
## Description
**API Operations on Settings objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | publish_observables |
| type | settings |
| settings | {'publish_observables': False} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Settings object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateRESTSettings' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateRESTSettings"
    data:
        id: "publish_observables"
        type: "settings"
        settings: {'publish_observables': False}
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```