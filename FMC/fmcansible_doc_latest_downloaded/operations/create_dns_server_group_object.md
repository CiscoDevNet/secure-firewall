# createDNSServerGroupObject

The createDNSServerGroupObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dnsservergroups](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dnsservergroups.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the DNS Server Group object associated with the specified ID. If no ID is specified for a GET, retrieves list of all DNS Server Group objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| timeout | 3 |
| name | DNSServerGroupObjectName1 |
| type | DNSServerGroupObject |
| defaultdomain | txcisco.com |
| dnsservers | [{'name-server': 'IPv4/IPv6hostaddress1'}, {'name-server': 'IPv4/IPv6hostaddress2'}, {'name-server': 'IPv4/IPv6hostaddress3'}, {'name-server': 'IPv4/IPv6hostaddress4'}, {'name-server': 'IPv4/IPv6hostaddress5'}, {'name-server': 'IPv4/IPv6hostaddress6'}] |
| retries | 3 |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createDNSServerGroupObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createDNSServerGroupObject"
    data:
        timeout: 3
        name: "DNSServerGroupObjectName1"
        type: "DNSServerGroupObject"
        defaultdomain: "txcisco.com"
        dnsservers: [{'name-server': 'IPv4/IPv6hostaddress1'}, {'name-server': 'IPv4/IPv6hostaddress2'}, {'name-server': 'IPv4/IPv6hostaddress3'}, {'name-server': 'IPv4/IPv6hostaddress4'}, {'name-server': 'IPv4/IPv6hostaddress5'}, {'name-server': 'IPv4/IPv6hostaddress6'}]
        retries: 3
    path_params:
        domainUUID: "{{ domain_uuid }}"

```