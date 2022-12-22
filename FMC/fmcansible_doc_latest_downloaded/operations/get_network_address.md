# getNetworkAddress

The getNetworkAddress operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/networkaddresses](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/networkaddresses.md) path.&nbsp;
## Description
**Retrieves list of all  network and host objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> To be used in conjunction with <code>"unusedOnly:true"</code> to search for unused objects and <code>"nameOrValue:{nameOrValue}"</code> to search for both name and value and <code>"type:{subType}"</code> to search for specific subType of the network object. <code>"type:{FQDN,RANGE,HOST,NETWORK}"</code> is for include and <code>"type!{FQDN,RANGE,HOST,NETWORK}"</code> is for exclude. To search for wildcard object type:NETWORK;includeWildcard:true. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getNetworkAddress' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getNetworkAddress"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```