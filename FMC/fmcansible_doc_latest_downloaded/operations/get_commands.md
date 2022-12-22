# getCommands

The getCommands operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/devices/devicerecords/{containerUUID}/operational/commands](/paths//api/fmc_config/v1/domain/{domain_uuid}/devices/devicerecords/{container_uuid}/operational/commands.md) path.&nbsp;
## Description
**Retrieves the show command output from the device. Make sure the minimum device version required for using commands api is >= 6.6.0.<br/> This api supports multi threading. Only 1 request can be handled per device concurrently and across devices upto 10 devices are supported by commands api concurrently.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| command | True | string <td colspan=3> The command filter query parameter should have value of show commands. The maximum word size of this field is 2. For eg: show interface, show running-config etc. |
| parameters | False | string <td colspan=3> The parameters filter query parameter should have values containing command values exceeding word size of 2 should be given as part of parameters field. For eg: ip brief, vpn etc. |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getCommands' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getCommands"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        command: "{{ command }}"
        parameters: "{{ parameters }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```