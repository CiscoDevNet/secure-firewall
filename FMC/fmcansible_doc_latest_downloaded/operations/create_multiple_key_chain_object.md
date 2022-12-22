# createMultipleKeyChainObject

The createMultipleKeyChainObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/keychains](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/keychains.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Keychain object associated with the specified ID. If no ID is specified for a GET, retrieves list of all Keychain objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | KeyChainObjectName1 |
| type | KeyChainObject |
| overridable | False |
| keys | [{'keyId': 2, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DURATION', 'endLifeTimeValue': '234'}, 'authAlgorithm': 'md5'}, {'keyId': 24, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'INFINITE'}, 'authAlgorithm': 'md5'}, {'keyId': 3, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}, {'keyId': 34, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}, {'keyId': 4, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}, {'keyId': 5, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for KeyChain objects. |

## Example
```yaml
- name: Execute 'createMultipleKeyChainObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleKeyChainObject"
    data:
        name: "KeyChainObjectName1"
        type: "KeyChainObject"
        overridable: False
        keys: [{'keyId': 2, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DURATION', 'endLifeTimeValue': '234'}, 'authAlgorithm': 'md5'}, {'keyId': 24, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'INFINITE'}, 'authAlgorithm': 'md5'}, {'keyId': 3, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}, {'keyId': 34, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}, {'keyId': 4, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}, {'keyId': 5, 'authString': {'cryptoEncryptionType': 'PLAINTEXT', 'cryptoKeyString': 'keyString'}, 'acceptLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'sendLifeTime': {'startLifeTimeValue': '2018-08-25T12:14:23', 'endLifetimeType': 'DATETIME', 'endLifeTimeValue': '2018-08-27T12:14:23'}, 'authAlgorithm': 'md5'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```