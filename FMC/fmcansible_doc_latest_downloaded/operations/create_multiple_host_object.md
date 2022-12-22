# createMultipleHostObject

The createMultipleHostObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/hosts](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/hosts.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the host object associated with the specified ID. If no ID is specified for a GET, retrieves list of all host objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | TestHost |
| type | Host |
| value | 10.5.3.20 |
| description | Test Description |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for host objects. |

## Example
```yaml
- name: Execute 'createMultipleHostObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleHostObject"
    data:
        name: "TestHost"
        type: "Host"
        value: "10.5.3.20"
        description: "Test Description"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```