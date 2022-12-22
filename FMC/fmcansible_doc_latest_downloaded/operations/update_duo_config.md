# updateDuoConfig

The updateDuoConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/users/duoconfigs/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/users/duoconfigs/{object_id}.md) path.&nbsp;
## Description
**Retrieves, creates, or modifies the Duo configuration associated with the specified ID. If no ID is specified for a GET, retrieves list of all Duo configurations. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | duoConfigUUID |
| type | DuoConfig |
| enabled | True |
| duoIKey | DIT8HUD89ANP1YS35MRN |
| duoSKey | y5jyWnedEERRMHP2Xul6LzNW8M3gtQ5ekJYQOl6J |
| duoHostName | api-1234.duosecurity.com |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Duo configuration. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateDuoConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateDuoConfig"
    data:
        id: "duoConfigUUID"
        type: "DuoConfig"
        enabled: True
        duoIKey: "DIT8HUD89ANP1YS35MRN"
        duoSKey: "y5jyWnedEERRMHP2Xul6LzNW8M3gtQ5ekJYQOl6J"
        duoHostName: "api-1234.duosecurity.com"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```