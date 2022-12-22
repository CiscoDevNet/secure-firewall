# updateMultipleDynamicAttributeFeedConfig

The updateMultipleDynamicAttributeFeedConfig operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/integration/dynamicattributesfeeds](/paths//api/fmc_config/v1/domain/{domain_uuid}/integration/dynamicattributesfeeds.md) path.&nbsp;
## Description
**Gets or updates Dynamic Attributes Feeds. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| subscribed | boolean |
| feeds | [{'id': 'id', 'name': 'Some text', 'description': 'Some text', 'subscribed': 'true', 'deprecated': 'false', 'type': 'DynamicAttributesFeed'}, {'id': 'id', 'name': 'Some text', 'description': 'Some text', 'subscribed': 'true', 'deprecated': 'false', 'type': 'DynamicAttributesFeed'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | True | boolean <td colspan=3> Enables bulk update of dynamic attributes feeds. |

## Example
```yaml
- name: Execute 'updateMultipleDynamicAttributeFeedConfig' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateMultipleDynamicAttributeFeedConfig"
    data:
        subscribed: "boolean"
        feeds: [{'id': 'id', 'name': 'Some text', 'description': 'Some text', 'subscribed': 'true', 'deprecated': 'false', 'type': 'DynamicAttributesFeed'}, {'id': 'id', 'name': 'Some text', 'description': 'Some text', 'subscribed': 'true', 'deprecated': 'false', 'type': 'DynamicAttributesFeed'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"

```