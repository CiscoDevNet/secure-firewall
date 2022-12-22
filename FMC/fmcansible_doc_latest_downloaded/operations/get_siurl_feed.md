# getSIURLFeed

The getSIURLFeed operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/siurlfeeds/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/siurlfeeds/{object_id}.md) path.&nbsp;
## Description
**Retrieves the Security Intelligence url feed object associated with the specified ID. If no ID is specified, retrieves list of all Security Intelligence url feed objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of Security Intelligence url feed object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSIURLFeed' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSIURLFeed"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```