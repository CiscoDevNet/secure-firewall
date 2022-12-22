# createDeploymentRequest

The createDeploymentRequest operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deployment/deploymentrequests](/paths//api/fmc_config/v1/domain/{domain_uuid}/deployment/deploymentrequests.md) path.&nbsp;
## Description
**Creates a request for deploying configuration changes to devices. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | DeploymentRequest |
| version | 1457566762351 |
| forceDeploy | False |
| ignoreWarning | True |
| deviceList | ['d94f7ada-d141-11e5-acf3-c41f7e67fb1b'] |
| deploymentNote | yournotescomehere |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createDeploymentRequest' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createDeploymentRequest"
    data:
        type: "DeploymentRequest"
        version: "1457566762351"
        forceDeploy: False
        ignoreWarning: True
        deviceList: ['d94f7ada-d141-11e5-acf3-c41f7e67fb1b']
        deploymentNote: "yournotescomehere"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```