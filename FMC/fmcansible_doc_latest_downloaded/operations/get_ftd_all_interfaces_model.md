# getFTDAllInterfacesModel

The getFTDAllInterfacesModel operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/ftdallinterfaces](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/ftdallinterfaces.md) path.&nbsp;
## Description
**Retrieves all types of interfaces.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> This is a query parameter to fetch specific type of interfaces. Supported Filter Criteria are : <code>cclEligibleInterface:{boolean};interfaceMode:{mode};virtualRouterId:{uuid};named:{boolean};</code> <br /> <code> cclEligibleInterface </code> : Filter to get ccl eligible interface, filter value should always be <code>true</code>. <br> <code> interfaceMode </code> : Filter using interface mode.Supported only for routed device. Allowed value is <code>ROUTED</code> Cannot be used with cclEligibleInterface filter. <br/> <code>virtualRouterId </code> : Supported only for routed device. Cannot be used with cclEligibleInterface filter. <br /> <code> named </code> : Supported only for routed device. Cannot be used with cclEligibleInterface filter. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getFTDAllInterfacesModel' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getFTDAllInterfacesModel"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```