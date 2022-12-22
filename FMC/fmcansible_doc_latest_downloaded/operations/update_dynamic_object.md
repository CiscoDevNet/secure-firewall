# updateDynamicObject

The updateDynamicObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dynamicobjects/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dynamicobjects/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Dynamic Object associated with the specified ID. If no ID is specified for a GET, retrieves list of all Dynamic Objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | 005056AB-931D-0ed3-0000-004294967338 |
| name | Marketing |
| description | IPs of marketing department changed |
| type | DynamicObject |
| objectType | IP |
| agentId | agent_007 |
| topicName | aws365 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier or name of Dynamic Object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateDynamicObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateDynamicObject"
    data:
        id: "005056AB-931D-0ed3-0000-004294967338"
        name: "Marketing"
        description: "IPs of marketing department changed"
        type: "DynamicObject"
        objectType: "IP"
        agentId: "agent_007"
        topicName: "aws365"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```