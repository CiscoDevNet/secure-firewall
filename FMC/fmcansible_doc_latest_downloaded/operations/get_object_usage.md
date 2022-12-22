# getObjectUsage

The getObjectUsage operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/operational/usage](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/operational/usage.md) path.&nbsp;
## Description
**Find usage of specified object uuid and type across objects and policies.<br><br>Supported object types:<ul><li>Network: NetworkAddress, Host, Network, Range, FQDN, NetworkGroup</li><li>Port: Port, ProtocolPortObject, PortObjectGroup, ICMPV4Object, ICMPV6Object, AnyProtocolPortObject</li><li>VLAN tag: VlanTag, VlanGroupTag</li><li>URL: Url, UrlGroup</li></ul>**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | True | string <td colspan=3> Specify uuid <code>"uuid:object-uuid"</code> and <code>"type:object-type"</code> and type of object |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getObjectUsage' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getObjectUsage"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```