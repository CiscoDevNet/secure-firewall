# getSIDNSFeed

The getSIDNSFeed operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/sidnsfeeds/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/sidnsfeeds/{object_id}.md) path.&nbsp;
## Description
**Retrieves the Security Intelligence DNS feed objects associated with the specified ID. If no ID is specified for a GET, retrieves list of all Security Intelligence DNS feed objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for Security Intelligence DNS feed object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSIDNSFeed' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSIDNSFeed"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```