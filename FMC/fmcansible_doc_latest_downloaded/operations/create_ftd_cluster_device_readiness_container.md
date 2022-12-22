# createFTDClusterDeviceReadinessContainer

The createFTDClusterDeviceReadinessContainer operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deviceclusters/ftdclusterreadinesscheck](/paths//api/fmc_config/v1/domain/{domain_uuid}/deviceclusters/ftdclusterreadinesscheck.md) path.&nbsp;
## Description
**Represents Cluster compatibility status for control(Readiness to become control) and data devices(compatible with control). This Readiness check is for platforms that support cluster bootstrap from FMC (for e.g.4200) _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| skipControlReadiness | False | string <td colspan=3> This is a query parameter, if given as true (skipControlReadiness=true) skips control readiness check and performs data devices compatibility with control.  |

## Example
```yaml
- name: Execute 'createFTDClusterDeviceReadinessContainer' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createFTDClusterDeviceReadinessContainer"
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        skipControlReadiness: "{{ skip_control_readiness }}"

```