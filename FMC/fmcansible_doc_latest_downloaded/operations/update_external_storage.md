# updateExternalStorage

The updateExternalStorage operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/integration/externalstorage/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/integration/externalstorage/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the external event storage config. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | externalStorageUUID |
| type | ExternalStorage |
| crossLaunchEnabled | True |
| doNotStoreConnectionEvents | False |
| isLinaLoggingEnabled | False |
| remoteQueryHost | example.com |
| remoteQueryPort | 443 |
| remoteQueryCert | Remote Query Cert |
| uiHost | example.com |
| uiPort | 443 |
| logHost | 10.20.30.40 |
| logPort | 8514 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for an external event storage config. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateExternalStorage' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateExternalStorage"
    data:
        id: "externalStorageUUID"
        type: "ExternalStorage"
        crossLaunchEnabled: True
        doNotStoreConnectionEvents: False
        isLinaLoggingEnabled: False
        remoteQueryHost: "example.com"
        remoteQueryPort: 443
        remoteQueryCert: "Remote Query Cert"
        uiHost: "example.com"
        uiPort: 443
        logHost: "10.20.30.40"
        logPort: 8514
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```