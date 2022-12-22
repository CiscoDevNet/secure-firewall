# getVpnIkeSettings

The getVpnIkeSettings operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns/{containerUUID}/ikesettings/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns/{container_uuid}/ikesettings/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKE Settings associated with the specified ID inside a VPN Site To Site Topology. If no ID is specified for a GET, retrieves Ike Settings of a topology.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for an Ike Settings policy in a Site to Site VPN topology. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getVpnIkeSettings' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getVpnIkeSettings"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```