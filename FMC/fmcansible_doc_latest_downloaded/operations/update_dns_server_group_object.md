# updateDNSServerGroupObject

The updateDNSServerGroupObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/dnsservergroups/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/dnsservergroups/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the DNS Server Group object associated with the specified ID. If no ID is specified for a GET, retrieves list of all DNS Server Group objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| dnsservers | [{'name-server': 'IPv4/IPv6hostaddress1'}, {'name-server': 'IPv4/IPv6hostaddress2'}] |
| retries | 1 |
| defaultdomain | cisco.com |
| type | DNSServerGroupObject |
| name | DNSServerGroupObjectName1 |
| timeout | 1 |
| id | DNSServerGroupObjectUUID |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for DNS Server Group object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateDNSServerGroupObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateDNSServerGroupObject"
    data:
        dnsservers: [{'name-server': 'IPv4/IPv6hostaddress1'}, {'name-server': 'IPv4/IPv6hostaddress2'}]
        retries: 1
        defaultdomain: "cisco.com"
        type: "DNSServerGroupObject"
        name: "DNSServerGroupObjectName1"
        timeout: 1
        id: "DNSServerGroupObjectUUID"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```