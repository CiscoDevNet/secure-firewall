# updateKeyChainObject

The updateKeyChainObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/keychains/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/keychains/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Keychain object associated with the specified ID. If no ID is specified for a GET, retrieves list of all Keychain objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| keys | [{'keyId': 1, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}, {'keyId': 2, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DURATION', 'endLifeTimeValue': '234'}, 'authAlgorithm': 'md5'}] |
| type | KeyChainObject |
| name | KeyChainObjectName1 |
| description | description for keychain object |
| overridable | False |
| id | KeyChainUUID |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for KeyChain object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateKeyChainObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateKeyChainObject"
    data:
        keys: [{'keyId': 1, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}, {'keyId': 2, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DURATION', 'endLifeTimeValue': '234'}, 'authAlgorithm': 'md5'}]
        type: "KeyChainObject"
        name: "KeyChainObjectName1"
        description: "description for keychain object"
        overridable: False
        id: "KeyChainUUID"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```