# updateRESTObservable

The updateRESTObservable operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/observable/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/observable/{object_id}.md) path.&nbsp;
## Description
**API Operations on Observable objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| inheritedProperty | {'publish': True, 'expirationTime': 1493929252, 'allowlist': False, 'action': 'monitor', 'ttl': 90} |
| observableType | IPV_4_ADDR |
| effectiveProperty | {'publish': True, 'expirationTime': 1493929252, 'allowlist': False, 'action': 'monitor', 'ttl': 90} |
| indicatorCount | 1 |
| updatedAt | 1486153252 |
| value | ipAddressValue |
| id | observableUUID |
| type | observable |
| name | Observable name 2 |
| version | 1.0.0 |
| customProperty | {'allowlist': True} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Observable. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateRESTObservable' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateRESTObservable"
    data:
        inheritedProperty: {'publish': True, 'expirationTime': 1493929252, 'allowlist': False, 'action': 'monitor', 'ttl': 90}
        observableType: "IPV_4_ADDR"
        effectiveProperty: {'publish': True, 'expirationTime': 1493929252, 'allowlist': False, 'action': 'monitor', 'ttl': 90}
        indicatorCount: 1
        updatedAt: 1486153252
        value: "ipAddressValue"
        id: "observableUUID"
        type: "observable"
        name: "Observable name 2"
        version: "1.0.0"
        customProperty: {'allowlist': True}
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```