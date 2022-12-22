# deleteKeyChainObject

The deleteKeyChainObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/keychains/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/keychains/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Keychain object associated with the specified ID. If no ID is specified for a GET, retrieves list of all Keychain objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for KeyChain object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteKeyChainObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteKeyChainObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```