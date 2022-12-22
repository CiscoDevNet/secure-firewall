# getSINetworkFeed

The getSINetworkFeed operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/sinetworkfeeds/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/sinetworkfeeds/{object_id}.md) path.&nbsp;
## Description
**APIs for Security Intelligence network feed.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of Security Intelligence network feed. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSINetworkFeed' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSINetworkFeed"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```