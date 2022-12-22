# updateProtocolPortObject

The updateProtocolPortObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/protocolportobjects/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/protocolportobjects/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the protocol(tcp/udp) port object associated with the specified ID. If no ID is specified for a GET, retrieves list of all protocol(tcp/udp) port objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | protocoPortObj1UUID |
| name | protocolport_obj1_updated |
| type | ProtocolPortObject |
| protocol | TCP |
| port | 1 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateProtocolPortObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateProtocolPortObject"
    data:
        id: "protocoPortObj1UUID"
        name: "protocolport_obj1_updated"
        type: "ProtocolPortObject"
        protocol: "TCP"
        port: 1
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```