# updateFQDNObject

The updateFQDNObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/fqdns/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/fqdns/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the FQDN object associated with the specified ID. If no ID is specified for a GET, retrieves list of all FQDN objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | FQDN |
| value | www.cisco.com |
| dnsResolution | IPV6_ONLY |
| overridable | False |
| description | Test Description |
| id | 5555-6666-7777-8888 |
| name | TestFQDN |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for FQDN object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateFQDNObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateFQDNObject"
    data:
        type: "FQDN"
        value: "www.cisco.com"
        dnsResolution: "IPV6_ONLY"
        overridable: False
        description: "Test Description"
        id: "5555-6666-7777-8888"
        name: "TestFQDN"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```