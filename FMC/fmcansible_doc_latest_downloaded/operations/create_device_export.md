# createDeviceExport

The createDeviceExport operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/operational/exports](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/operational/exports.md) path.&nbsp;
## Description
**Package and export device configuration of specified FTDs  _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| deviceList | ['00e5091a-ca4e-11eb-872b-edfdb3a31887', '7de01414-02b7-4693-acf1-8f30a92f2c1f', 'ec48d989-fed8-4004-99a0-7e6d2a2319d5', '02531776-670d-46e7-8e0f-045070a27d59'] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createDeviceExport' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createDeviceExport"
    data:
        deviceList: ['00e5091a-ca4e-11eb-872b-edfdb3a31887', '7de01414-02b7-4693-acf1-8f30a92f2c1f', 'ec48d989-fed8-4004-99a0-7e6d2a2319d5', '02531776-670d-46e7-8e0f-045070a27d59']
    path_params:
        domainUUID: "{{ domain_uuid }}"

```