# updateFTDHAMonitoredInterfaces

The updateFTDHAMonitoredInterfaces operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devicehapairs/ftddevicehapairs/{containerUUID}/monitoredinterfaces/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/devicehapairs/ftddevicehapairs/{container_uuid}/monitoredinterfaces/{object_id}.md) path.&nbsp;
## Description
**Retrieves or modifies the FTD HA Monitored interface policy record associated with the specified FTD HA pair. If no ID is specified for a GET, retrieves list of all FTD HA monitored interface policy records. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | <monitored_interface_policy_uuid> |
| name | <interface-nameif> |
| ipv4Configuration | {'standbyIPv4Address': '192.0.2.2'} |
| ipv6Configuration | {'standbyIPv6LinkLocalAddress': 'FE80::C800:EFF:FE74:9', 'ipv6ActiveStandbyPair': [{'activeIPv6': '2006::/32', 'standbyIPv6': '2006::31'}, {'activeIPv6': '2005::/32', 'standbyIPv6': '2005::31'}]} |
| monitorForFailures | true |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier of a FTD HA Monitored interface policy. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateFTDHAMonitoredInterfaces' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateFTDHAMonitoredInterfaces"
    data:
        id: "<monitored_interface_policy_uuid>"
        name: "<interface-nameif>"
        ipv4Configuration: {'standbyIPv4Address': '192.0.2.2'}
        ipv6Configuration: {'standbyIPv6LinkLocalAddress': 'FE80::C800:EFF:FE74:9', 'ipv6ActiveStandbyPair': [{'activeIPv6': '2006::/32', 'standbyIPv6': '2006::31'}, {'activeIPv6': '2005::/32', 'standbyIPv6': '2005::31'}]}
        monitorForFailures: "true"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```