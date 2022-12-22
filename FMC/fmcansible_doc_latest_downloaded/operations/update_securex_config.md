# updateSecurexConfig

The updateSecurexConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/integration/securexconfigs/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/integration/securexconfigs/{object_id}.md) path.&nbsp;
## Description
**Retrieves, creates, or modifies the SecureX configuration associated with the specified ID. If no ID is specified for a GET, retrieves list of all SecureX configurations. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | securexConfigUUID |
| type | SecurexConfig |
| enabled | True |
| clientId |  |
| clientPassword | ********* |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the SecureX configuration. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateSecurexConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateSecurexConfig"
    data:
        id: "securexConfigUUID"
        type: "SecurexConfig"
        enabled: True
        clientId: ""
        clientPassword: "*********"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```