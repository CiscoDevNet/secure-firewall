# updateNetworkModule

The updateNetworkModule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/chassis/fmcmanagedchassis/{containerUUID}/networkmodules/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/chassis/fmcmanagedchassis/{container_uuid}/networkmodules/{object_id}.md) path.&nbsp;
## Description
**Retrieves list of all network modules available on the specified device. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| id | networkModuleUUID |
| moduleState | DISABLED |
| type | NetworkModule |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a network module. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateNetworkModule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateNetworkModule"
    data:
        id: "networkModuleUUID"
        moduleState: "DISABLED"
        type: "NetworkModule"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```