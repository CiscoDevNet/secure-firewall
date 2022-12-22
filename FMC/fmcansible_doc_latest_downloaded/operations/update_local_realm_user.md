# updateLocalRealmUser

The updateLocalRealmUser operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/localrealmusers/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/localrealmusers/{object_id}.md) path.&nbsp;
## Description
**Retrieves the local realm user object associated with the specified ID. If no ID is specified, retrieves list of all local realm user objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | Test1 |
| id | Local-Realm-User-UUID-1 |
| type | LocalRealmUser |
| password | TESTPASSWORD_UPDATE |
| realm | {'id': 'realmUUID', 'type': 'Realm', 'name': 'ntd-test.cisco.com'} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of local realm user. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateLocalRealmUser' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateLocalRealmUser"
    data:
        name: "Test1"
        id: "Local-Realm-User-UUID-1"
        type: "LocalRealmUser"
        password: "TESTPASSWORD_UPDATE"
        realm: {'id': 'realmUUID', 'type': 'Realm', 'name': 'ntd-test.cisco.com'}
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```