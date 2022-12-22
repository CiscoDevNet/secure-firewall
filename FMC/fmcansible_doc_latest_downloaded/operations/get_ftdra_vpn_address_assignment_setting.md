# getFTDRAVpnAddressAssignmentSetting

The getFTDRAVpnAddressAssignmentSetting operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ravpns/{containerUUID}/addressassignmentsettings/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ravpns/{container_uuid}/addressassignmentsettings/{object_id}.md) path.&nbsp;
## Description
**Retrieves Address Assignment Setting inside a VPN RA Topology. If no ID is specified for a GET, retrieves list containing a single Address Assignment Setting entry of the topology.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Identifier for Address Assignment Setting in a RA VPN topology. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getFTDRAVpnAddressAssignmentSetting' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getFTDRAVpnAddressAssignmentSetting"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```