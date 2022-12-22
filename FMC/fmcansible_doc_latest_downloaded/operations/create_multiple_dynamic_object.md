# createMultipleDynamicObject

The createMultipleDynamicObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dynamicobjects](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dynamicobjects.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Dynamic Object associated with the specified ID. If no ID is specified for a GET, retrieves list of all Dynamic Objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | Marketing |
| description | IPs of marketing department |
| type | DynamicObject |
| objectType | IP |
| agentId | agent_007 |
| topicName | aws365 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create (POST) or delete (DELETE) of Dynamic Objects. |

## Example
```yaml
- name: Execute 'createMultipleDynamicObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleDynamicObject"
    data:
        name: "Marketing"
        description: "IPs of marketing department"
        type: "DynamicObject"
        objectType: "IP"
        agentId: "agent_007"
        topicName: "aws365"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```