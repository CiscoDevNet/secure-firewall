# getPendingChanges

The getPendingChanges operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/deployment/deployabledevices/{containerUUID}/pendingchanges](/paths//api/fmc_config/v1/domain/{domain_uuid}/deployment/deployabledevices/{container_uuid}/pendingchanges.md) path.&nbsp;
## Description
**Retrieves all the policy and object changes for the selected device.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> The filter criteria for which the details have to be fetched - Only works when "expanded" is set to "true". Examples: ParentEntityTypes:AccessPolicy, EntityUUID:0050568C-35A0-0ed3-0000-004294969351.To fetch the historical data pass the left and right job UUID. Example LeftJobUUID:4b9fe31c-34cc-11ea-8b36-8eb5492fc3a5;RightJobUUID:4b9fe31c-34cc-11ea-8b36-8eb5492fc3a3.For filter based on User add a filter using key word UserList.Example: UserList : user1,user2.  |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getPendingChanges' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getPendingChanges"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```