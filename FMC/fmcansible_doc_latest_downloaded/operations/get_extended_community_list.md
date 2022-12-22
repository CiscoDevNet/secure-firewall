# getExtendedCommunityList

The getExtendedCommunityList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/extendedcommunitylists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/extendedcommunitylists/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the ExtendedCommunityList object associated with the specified ID. If no ID is specified for a GET, retrieves list of all ExtendedCommunityList objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for ExtendedCommunityList object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the ExtendedCommunityList object on given target ID. |

## Example
```yaml
- name: Execute 'getExtendedCommunityList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getExtendedCommunityList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```