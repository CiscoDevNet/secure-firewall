# getIPv4AddressPool

The getIPv4AddressPool operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ipv4addresspools/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ipv4addresspools/{object_id}.md) path.&nbsp;
## Description
**Retrieves the IPv4 Address Pool object associated with the specified ID. If no ID is specified for a GET, retrieves list of all IPv4 Address Pool objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| overrideTargetId | False | string <td colspan=3> Retrieves the override(s) associated with the IPv4 Address Pool object on given target ID. |

## Example
```yaml
- name: Execute 'getIPv4AddressPool' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getIPv4AddressPool"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        overrideTargetId: "{{ override_target_id }}"

```