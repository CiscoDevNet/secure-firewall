# getVpnAdvancedSettings

The getVpnAdvancedSettings operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns/{containerUUID}/advancedsettings/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns/{container_uuid}/advancedsettings/{object_id}.md) path.&nbsp;
## Description
**Retrieves and modifies a Advanced settings inside a VPN Site To Site Topology. If no ID is specified for a GET, retrieves list containing a single AdvancedSettings entry of the topology.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for Advanced settings in a Site to Site VPN topology. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getVpnAdvancedSettings' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getVpnAdvancedSettings"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```