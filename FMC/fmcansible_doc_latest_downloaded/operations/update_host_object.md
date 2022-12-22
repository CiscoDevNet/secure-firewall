# updateHostObject

The updateHostObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/hosts/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/hosts/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the host object associated with the specified ID. If no ID is specified for a GET, retrieves list of all host objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | Host |
| value | 10.5.3.28 |
| overridable | False |
| description | Test Description |
| id | hostObject3UUID |
| name | TestHost |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for host object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateHostObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateHostObject"
    data:
        type: "Host"
        value: "10.5.3.28"
        overridable: False
        description: "Test Description"
        id: "hostObject3UUID"
        name: "TestHost"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```