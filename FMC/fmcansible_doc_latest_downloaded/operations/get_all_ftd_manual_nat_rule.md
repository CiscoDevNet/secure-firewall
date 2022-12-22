# getAllFTDManualNatRule

The getAllFTDManualNatRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftdnatpolicies/{containerUUID}/manualnatrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftdnatpolicies/{container_uuid}/manualnatrules.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the Manual NAT rule associated with the specified ID. Also, retrieves list of all Manual NAT rules.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| filter | False | string <td colspan=3> Value is of format : <code>"ids:id1,id2,...;sourceInterface:name1,name2,...;destinationInterface:name1,name2,...;<br/>originalSource:name1/value1,name2/value2,...;originalDestination:name1/value1,name2/value2,...;<br/>translatedSource:name1/value1,name2/value2,...;translatedDestination:name1/value1,name2/value2,...;<br/>originalSourcePort:name1/value1,name2/value2,...;originalDestinationPort:name1/value1,name2/value2,...;<br/>translatedSourcePort:name1/value1,name2/value2,...;translatedDestinationPort:name1/value1,name2/value2,...;"</code><br/><br/>ids:id1,id2,...etc. This ids is a comma-separated list of rule ids to fetch/delete</br>sourceInterface:SecurityZone/Interface group name (sec_zone_name1) can be given as value to fetch/delete nat rule<br/>destinationInterface:SecurityZone/Interface group name (sec_zone_name1) can be given as value to fetch/delete nat rule<br/>originalSource: Network object configured as Original source object name (object_name) or the value (10.1.2.3) of the object can be given<br/>originalDestination:Network object configured as Destination source object name (object_name) or the value (10.1.2.3) of the object can be given<br/>translatedSource:Network object configured as translated source object name (object_name) or the value (10.1.2.3) of the object can be given<br/>translatedDestination:Network object configured as translated Destination object name (object_name) or the value (10.1.2.3) of the object can be given<br/>originalSourcePort:Port object configured as Original Source Port object name (http) or value of the object as port no or protocol (tcp/80) can be given<br/>originalDestinationPort:Port object configured as Original Destination Port object name (http) or value of the object as port no or protocol (tcp/80) can be given<br/>translatedSourcePort:Port object configured as Translated Source Port object name (http) or value of the object as port no or protocol (tcp/80) can be given<br/>translatedDestinationPort:Port object configured as Translated Destination Port object name (http) or value of the object as port no or protocol (tcp/80) can be given"<br/> |
| offset | False | integer <td colspan=3> Index of first item to return. |
| limit | False | integer <td colspan=3> Number of items to return. |
| expanded | False | boolean <td colspan=3> If set to true, the GET response displays a list of objects with additional attributes. |

## Example
```yaml
- name: Execute 'getAllFTDManualNatRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getAllFTDManualNatRule"
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        filter: "{{ filter }}"
        offset: "{{ offset }}"
        limit: "{{ limit }}"
        expanded: "{{ expanded }}"

```