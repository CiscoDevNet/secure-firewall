# getVpnEndpoint

The getVpnEndpoint operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftds2svpns/{containerUUID}/endpoints/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftds2svpns/{container_uuid}/endpoints/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies a specific Endpoint associated with the specified ID inside a VPN Site To Site Topology. If no ID is specifid for a GET, retrieves list of all Endpoints of a topology.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for an Endpoint in a Site to Site VPN topology. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getVpnEndpoint' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getVpnEndpoint"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```