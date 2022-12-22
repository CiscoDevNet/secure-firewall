# updateICMPV4Object

The updateICMPV4Object operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/icmpv4objects/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/icmpv4objects/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the icmpv4 object associated with the specified ID. If no ID is specified for a GET, retrieves list of all icmpv4 objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | icmpv4Object1UUID |
| name | icmpv4_obj1_updated |
| type | ICMPV4Object |
| icmpType | 3 |
| code | 1 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateICMPV4Object' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateICMPV4Object"
    data:
        id: "icmpv4Object1UUID"
        name: "icmpv4_obj1_updated"
        type: "ICMPV4Object"
        icmpType: "3"
        code: 1
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```