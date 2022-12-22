# createFTDS2SVpnModel

The createFTDS2SVpnModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the FTD Site to Site VPN topology associated with the specified ID. If no ID is specified for a GET, retrieves list of all FTD Site to Site VPN topologies. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createFTDS2SVpnModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createFTDS2SVpnModel"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```