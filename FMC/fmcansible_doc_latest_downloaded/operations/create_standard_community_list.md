# createStandardCommunityList

The createStandardCommunityList operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/standardcommunitylists](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/standardcommunitylists.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the StandardCommunityList object associated with the specified ID. If no ID is specified for a GET, retrieves list of all StandardCommunityList objects. _Check the response section for applicable examples (if any)._**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createStandardCommunityList' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createStandardCommunityList"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```