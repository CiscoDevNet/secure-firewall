# getPrefilterHitCount

The getPrefilterHitCount operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies/{containerUUID}/operational/hitcounts](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies/{container_uuid}/operational/hitcounts.md) path.&nbsp;
## Description
**Retrieves, refreshes and clears Hit Count**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | True | string <td colspan=3> Value is of format (including quotes): <code>"deviceId:{uuid};ids:{uuid1,uuid2,..};fetchZeroHitCount:{true|false}"</code><br/><code>deviceId</code> is UUID of device and is a mandatory field.<br/><code>ids</code> returns hitcounts of prefilter rules if set to list of rule UUIDs. If this key is not used, all prefilter rules will be returned (Note that this is applicable only in GET and DELETE operations). <br/><code>fetchZeroHitCount</code> returns only access rules whose hit count is zero if <code>true</code> (Note that this is applicable only in GET operation and if <code>ids</code> is not used). |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getPrefilterHitCount' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getPrefilterHitCount"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```