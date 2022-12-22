# updateFTDS2SVpnModel

The updateFTDS2SVpnModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the FTD Site to Site VPN topology associated with the specified ID. If no ID is specified for a GET, retrieves list of all FTD Site to Site VPN topologies. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | Cicso_S2S_Vpn |
| type | FTDS2SVpn |
| topologyType | POINT_TO_POINT |
| ikeV1Enabled | True |
| ikeV2Enabled | False |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for FTD Site to Site VPN topology. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateFTDS2SVpnModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateFTDS2SVpnModel"
    data:
        name: "Cicso_S2S_Vpn"
        type: "FTDS2SVpn"
        topologyType: "POINT_TO_POINT"
        ikeV1Enabled: True
        ikeV2Enabled: False
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```