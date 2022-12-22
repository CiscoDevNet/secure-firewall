# getISESecurityGroupTag

The getISESecurityGroupTag operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/isesecuritygrouptags/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/isesecuritygrouptags/{object_id}.md) path.&nbsp;
## Description
**Retrieves the ISE security group tag object with the specified ID. If no ID is specified, retrieves list of all ISE security group tag objects.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the ISE security group tag object. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'getISESecurityGroupTag' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getISESecurityGroupTag"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```