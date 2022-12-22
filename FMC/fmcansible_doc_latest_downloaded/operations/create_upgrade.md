# createUpgrade

The createUpgrade operation handles configuration related to [/api/fmc_platform/v1/updates/upgrades](/paths//api/fmc_platform/v1/updates/upgrades.md) path.&nbsp;
## Description
**API to trigger upgrade. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| upgradePackage | {'id': '73207350-8395-11e8-845b-e5a3cc8a21de', 'type': 'UpgradePackage'} |
| targets | [{'id': '1251b782-7922-11e8-85d1-9ce8632d3182', 'type': 'Device', 'name': 'vFTD-1'}, {'id': '88f052b8-7922-11e8-a602-840c6cea8ca5', 'type': 'Device', 'name': 'vFTD-2'}] |
| pushUpgradeFileOnly | true |

## Example
```yaml
- name: Execute 'createUpgrade' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createUpgrade"
    data:
        upgradePackage: {'id': '73207350-8395-11e8-845b-e5a3cc8a21de', 'type': 'UpgradePackage'}
        targets: [{'id': '1251b782-7922-11e8-85d1-9ce8632d3182', 'type': 'Device', 'name': 'vFTD-1'}, {'id': '88f052b8-7922-11e8-a602-840c6cea8ca5', 'type': 'Device', 'name': 'vFTD-2'}]
        pushUpgradeFileOnly: "true"

```