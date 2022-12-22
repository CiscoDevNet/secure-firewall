# getSINetworkList

The getSINetworkList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/sinetworklists/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/sinetworklists/{object_id}.md) path.&nbsp;
## Description
**APIs for Security Intelligence network list.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of Security Intelligence network list. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getSINetworkList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getSINetworkList"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```