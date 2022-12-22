# getFQDNObject

The getFQDNObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/fqdns/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/fqdns/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the FQDN object associated with the specified ID. If no ID is specified for a GET, retrieves list of all FQDN objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for FQDN object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the FQDN object on given target ID. |

## Example
```yaml
- name: Execute 'getFQDNObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getFQDNObject"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```