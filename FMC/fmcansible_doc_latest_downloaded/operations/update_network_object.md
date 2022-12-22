# updateNetworkObject

The updateNetworkObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/networks/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/networks/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the network objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all network objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | Network |
| value | 1.2.3.0/24 |
| overridable | False |
| description | Test Description |
| id | networkObjectUUID |
| name | network_obj_name |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateNetworkObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateNetworkObject"
    data:
        type: "Network"
        value: "1.2.3.0/24"
        overridable: False
        description: "Test Description"
        id: "networkObjectUUID"
        name: "network_obj_name"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```