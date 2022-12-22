# getFTDNatRule

The getFTDNatRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/ftdnatpolicies/{containerUUID}/natrules/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/ftdnatpolicies/{container_uuid}/natrules/{object_id}.md) path.&nbsp;
## Description
**Retrieves list of all NAT rules (manual and auto) associated with the specified policy ID.**

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a NAT rule. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| section | False | string <td colspan=3> Retrieves nat rule in given section. Allowed value is 'before_auto', 'auto' and 'after_auto'. |
| filter | False | string <td colspan=3> Value is of format : <code>"ids:id1,id2,...;sourceInterface:name1,name2,...;destinationInterface:name1,name2,...;<br/>originalSource:name1/value1,name2/value2,...;originalDestination:name1/value1,name2/value2,...;<br/>translatedSource:name1/value1,name2/value2,...;translatedDestination:name1/value1,name2/value2,...;<br/>originalSourcePort:name1/value1,name2/value2,...;originalDestinationPort:name1/value1,name2/value2,...;<br/>translatedSourcePort:name1/value1,name2/value2,...;translatedDestinationPort:name1/value1,name2/value2,...;"</code><br/><br/>ids:id1,id2,...etc. This ids is a comma-separated list of rule ids to fetch/delete</br>sourceInterface:SecurityZone/Interface group name (sec_zone_name1) can be given as value to fetch/delete nat rule<br/>destinationInterface:SecurityZone/Interface group name (sec_zone_name1) can be given as value to fetch/delete nat rule<br/>originalSource: Network object configured as Original source object name (object_name) or the value (10.1.2.3) of the object can be given<br/>originalDestination:Network object configured as Destination source object name (object_name) or the value (10.1.2.3) of the object can be given<br/>translatedSource:Network object configured as translated source object name (object_name) or the value (10.1.2.3) of the object can be given<br/>translatedDestination:Network object configured as translated Destination object name (object_name) or the value (10.1.2.3) of the object can be given<br/>originalSourcePort:Port object configured as Original Source Port object name (http) or value of the object as port no or protocol (tcp/80) can be given<br/>originalDestinationPort:Port object configured as Original Destination Port object name (http) or value of the object as port no or protocol (tcp/80) can be given<br/>translatedSourcePort:Port object configured as Translated Source Port object name (http) or value of the object as port no or protocol (tcp/80) can be given<br/>translatedDestinationPort:Port object configured as Translated Destination Port object name (http) or value of the object as port no or protocol (tcp/80) can be given"<br/> |

## Example
```yaml
- name: Execute 'getFTDNatRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "getFTDNatRule"
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        section: "{{ section }}"
        filter: "{{ filter }}"

```