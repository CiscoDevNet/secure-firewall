# getCertificateMapModel

The getCertificateMapModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/certificatemaps/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/certificatemaps/{object_id}.md) path.&nbsp;
## Description
**Retrieves the Certificate Map associated with the specified ID. If no ID is specified for a GET, retrieves list of all Certificate Map objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for Certificate Map object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getCertificateMapModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getCertificateMapModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```