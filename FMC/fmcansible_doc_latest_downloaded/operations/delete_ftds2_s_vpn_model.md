# deleteFTDS2SVpnModel

The deleteFTDS2SVpnModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the FTD Site to Site VPN topology associated with the specified ID. If no ID is specified for a GET, retrieves list of all FTD Site to Site VPN topologies. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for FTD Site to Site VPN topology. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'deleteFTDS2SVpnModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "deleteFTDS2SVpnModel"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```