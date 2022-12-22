# createMultipleTunnelTags

The createMultipleTunnelTags operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/tunneltags](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/tunneltags.md) path.&nbsp;
## Description
**Retrieves the tunnel tag object associated with the specified ID. If no ID is specified, retrieves list of all tunnel tag objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| type | TunnelTag |
| name | NewTunnelTag |
| description | Tunnel Tag description |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> This parameter specifies that bulk operation is being used in the query. This parameter is required for bulk object operations. Only bulk POST is currently supported for tunnel tags. Allowed values are 'true' and 'false'. |

## Example
```yaml
- name: Execute 'createMultipleTunnelTags' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleTunnelTags"
    data:
        type: "TunnelTag"
        name: "NewTunnelTag"
        description: "Tunnel Tag description"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```