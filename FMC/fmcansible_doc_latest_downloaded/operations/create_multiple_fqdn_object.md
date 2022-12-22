# createMultipleFQDNObject

The createMultipleFQDNObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/fqdns](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/fqdns.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the FQDN object associated with the specified ID. If no ID is specified for a GET, retrieves list of all FQDN objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | TestFQDN |
| type | FQDN |
| value | downloads.cisco.com |
| dnsResolution | IPV4_ONLY |
| description | Test Description |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> Enables bulk create for FQDN objects. |

## Example
```yaml
- name: Execute 'createMultipleFQDNObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleFQDNObject"
    data:
        name: "TestFQDN"
        type: "FQDN"
        value: "downloads.cisco.com"
        dnsResolution: "IPV4_ONLY"
        description: "Test Description"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```