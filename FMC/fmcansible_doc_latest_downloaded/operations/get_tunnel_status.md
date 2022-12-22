# getTunnelStatus

The getTunnelStatus operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/health/tunnelstatuses](/paths//api/fmc_config/v1/domain/{domain_uuid}/health/tunnelstatuses.md) path.&nbsp;
## Description
**Retrieves tunnel status for S2S VPN on all managed FTDs.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> The allowed filters are <code>"vpnTopologyId:{uuid}"</code> which filters the tunnel statuses by S2S VPN Topology id, <code>"deviceId:{UUID}"</code> which filters the tunnel statuses by Device id, <code>status:{TUNNEL_UP|TUNNEL_DOWN|UNKNOWN}</code> which filters the tunnel statuses by Tunnel Status and <code>"sortBy{:|<|>}{Topology|Device|Status|LastChange}"</code>. Filter operators `:` and `<` sorts in ascending order and `>` sorts in descending order.    |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getTunnelStatus' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getTunnelStatus"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```