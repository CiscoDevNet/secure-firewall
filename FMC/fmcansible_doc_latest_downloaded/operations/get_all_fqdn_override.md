# getAllFQDNOverride

The getAllFQDNOverride operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/fqdns/{containerUUID}/overrides](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/fqdns/{container_uuid}/overrides.md) path.&nbsp;
## Description
**Retrieves all(Domain and Device) overrides on a FQDN object.Response will always be in expanded form. If passed, the "expanded" query parameter will be ignored.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllFQDNOverride' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllFQDNOverride"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```