# createFTDBridgeGroupInterface

The createFTDBridgeGroupInterface operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/bridgegroupinterfaces](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/bridgegroupinterfaces.md) path.&nbsp;
## Description
**Retrieves the bridge group interface associated with the specified NGFW device ID and interface ID. If no interface ID is specified, retrieves list of all bridge group interfaces associated with the specified NGFW device ID. <div class="alert alert-warning">More details on netmod events(out of sync interfaces):<b> GET /interfaceevents</b></div> _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createFTDBridgeGroupInterface' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createFTDBridgeGroupInterface"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```