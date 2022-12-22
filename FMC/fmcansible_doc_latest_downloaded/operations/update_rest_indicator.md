# updateRESTIndicator

The updateRESTIndicator operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/indicator/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/indicator/{object_id}.md) path.&nbsp;
## Description
**API Operations on Indicator objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| inheritedProperty | {'ttl': 90, 'publish': True, 'allowlist': False, 'expirationTime': 1506280028, 'action': 'monitor'} |
| effectiveProperty | {'ttl': 90, 'publish': True, 'allowlist': False, 'expirationTime': 1506280028, 'action': 'monitor'} |
| customProperty | {'publish': True, 'action': 'block'} |
| feedId | feedUUID |
| equation | {'children': [{'children': [{'isRealized': False, 'type': 'IPV_4_ADDR', 'value': 'IPV_4_ADDR:c4a098d02ba0407e165c14996f8eae6b65a119a2'}], 'condition': 'EQUALS', 'applyCondition': 'ANY', 'isRealized': False}], 'isRealized': False, 'op': 'OR'} |
| updatedAt | 1499842559 |
| sourceName | Test Flat File IPV4 |
| containsUnsupported | False |
| containsInvalid | False |
| observables | [{'inheritedProperty': {'ttl': 90, 'publish': True, 'allowlist': False, 'expirationTime': 1506280028, 'action': 'monitor'}, 'effectiveProperty': {'ttl': 90, 'publish': True, 'allowlist': False, 'expirationTime': 1506280028, 'action': 'monitor'}, 'indicatorCount': 1, 'observableType': 'IPV_4_ADDR', 'updatedAt': 1498504028, 'value': 'ipAddressValue', 'id': 'IPV_4_ADDR:c4a098d02ba0407e165c14996f8eae6b65a119a2', 'type': 'observable', 'name': 'Observable', 'version': '1.0.0'}] |
| indicatorVersion | 1.0.0 |
| noRealizedIncidents | 0 |
| noPartialIncidents | 0 |
| id | indicatorUUID |
| type | indicator |
| name | Sample Indicator IPV4 |
| version | 1.0.0 |
| description | Indicator description changed |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Indicator. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateRESTIndicator' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateRESTIndicator"
    data:
        inheritedProperty: {'ttl': 90, 'publish': True, 'allowlist': False, 'expirationTime': 1506280028, 'action': 'monitor'}
        effectiveProperty: {'ttl': 90, 'publish': True, 'allowlist': False, 'expirationTime': 1506280028, 'action': 'monitor'}
        customProperty: {'publish': True, 'action': 'block'}
        feedId: "feedUUID"
        equation: {'children': [{'children': [{'isRealized': False, 'type': 'IPV_4_ADDR', 'value': 'IPV_4_ADDR:c4a098d02ba0407e165c14996f8eae6b65a119a2'}], 'condition': 'EQUALS', 'applyCondition': 'ANY', 'isRealized': False}], 'isRealized': False, 'op': 'OR'}
        updatedAt: 1499842559
        sourceName: "Test Flat File IPV4"
        containsUnsupported: False
        containsInvalid: False
        observables: [{'inheritedProperty': {'ttl': 90, 'publish': True, 'allowlist': False, 'expirationTime': 1506280028, 'action': 'monitor'}, 'effectiveProperty': {'ttl': 90, 'publish': True, 'allowlist': False, 'expirationTime': 1506280028, 'action': 'monitor'}, 'indicatorCount': 1, 'observableType': 'IPV_4_ADDR', 'updatedAt': 1498504028, 'value': 'ipAddressValue', 'id': 'IPV_4_ADDR:c4a098d02ba0407e165c14996f8eae6b65a119a2', 'type': 'observable', 'name': 'Observable', 'version': '1.0.0'}]
        indicatorVersion: "1.0.0"
        noRealizedIncidents: 0
        noPartialIncidents: 0
        id: "indicatorUUID"
        type: "indicator"
        name: "Sample Indicator IPV4"
        version: "1.0.0"
        description: "Indicator description changed"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```