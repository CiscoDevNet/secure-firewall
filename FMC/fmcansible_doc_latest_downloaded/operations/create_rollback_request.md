# createRollbackRequest

The createRollbackRequest operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deployment/rollbackrequests](/paths//api/fmc_config/v1/domain/{domain_uuid}/deployment/rollbackrequests.md) path.&nbsp;
## Description
**Creates a request for rollback configuration to devices. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | RollbackRequest |
| rollbackDeviceList | [{'deploymentJobId': '0050568B-9937-0ed3-0000-296352743514', 'deviceList': ['d0c422c8-9756-11ea-acb6-961f407b1a9c', '73dee6c4-9756-11ea-b7d5-c46fa36556b5']}, {'deploymentJobId': '0050568B-9937-0ed3-0000-300647710810', 'deviceList': ['88a4b666-9372-11ea-babd-9ebaf536312a']}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createRollbackRequest' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createRollbackRequest"
    data:
        type: "RollbackRequest"
        rollbackDeviceList: [{'deploymentJobId': '0050568B-9937-0ed3-0000-296352743514', 'deviceList': ['d0c422c8-9756-11ea-acb6-961f407b1a9c', '73dee6c4-9756-11ea-b7d5-c46fa36556b5']}, {'deploymentJobId': '0050568B-9937-0ed3-0000-300647710810', 'deviceList': ['88a4b666-9372-11ea-babd-9ebaf536312a']}]
    path_params:
        domainUUID: "{{ domain_uuid }}"

```