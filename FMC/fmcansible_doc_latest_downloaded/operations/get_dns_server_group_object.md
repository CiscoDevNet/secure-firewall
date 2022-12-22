# getDNSServerGroupObject

The getDNSServerGroupObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dnsservergroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dnsservergroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the DNS Server Group object associated with the specified ID. If no ID is specified for a GET, retrieves list of all DNS Server Group objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for DNS Server Group object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the object on given target ID. |

## Example
```yaml
- name: Execute 'getDNSServerGroupObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getDNSServerGroupObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```