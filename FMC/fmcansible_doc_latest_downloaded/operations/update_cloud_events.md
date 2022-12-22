# updateCloudEvents

The updateCloudEvents operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/integration/cloudeventsconfigs/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/integration/cloudeventsconfigs/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the cloud event configuration associated with the specified ID. If no ID is specified for a GET, retrieves a list of the singleton cloud event configuration object. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | CloudEventsConfigsUUID |
| type | CloudEventsConfig |
| sendIntrusionEvents | False |
| sendFileEvents | True |
| sendConnectionEvents | True |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for cloud event configuration. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateCloudEvents' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateCloudEvents"
    data:
        id: "CloudEventsConfigsUUID"
        type: "CloudEventsConfig"
        sendIntrusionEvents: False
        sendFileEvents: True
        sendConnectionEvents: True
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```