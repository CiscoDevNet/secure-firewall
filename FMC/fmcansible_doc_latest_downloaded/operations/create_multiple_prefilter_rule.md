# createMultiplePrefilterRule

The createMultiplePrefilterRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies/{containerUUID}/prefilterrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies/{container_uuid}/prefilterrules.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the prefilter rule associated with the specified policy ID and rule ID. If no ID is specified, retrieves list of all prefilter rules associated with the specified policy ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| action | FASTPATH/ANALYZE/BLOCK |
| enabled | True |
| type | PrefilterRule |
| name | Rule1 |
| sendEventsToFMC | False |
| ruleType | PREFILTER |
| bidirectional | False |
| logBegin | False |
| logEnd | False |
| vlanTags | {'objects': [{'type': 'VlanTag', 'name': 'vlan_tag_1', 'id': 'VlanTagUUID1'}, {'type': 'VlanTag', 'name': 'vlan_tag_2', 'id': 'VlanTagUUID2'}]} |
| sourceInterfaces | {'objects': [{'name': 'External', 'id': 'SecurityInterfaceUUID', 'type': 'SecurityZone'}]} |
| destinationInterfaces | {'objects': [{'name': 'Internal', 'id': 'SecurityInterfaceUUID', 'type': 'SecurityZone'}]} |
| sourcePorts | {'objects': [{'type': 'ProtocolPortObject', 'name': 'AOL', 'id': 'ProtocolPortObjectUUID'}]} |
| destinationPorts | {'objects': [{'type': 'ProtocolPortObject', 'name': 'Bittorrent', 'id': 'ProtocolPortObjectUUID'}]} |
| sourceNetworks | {'objects': [{'type': 'Host', 'id': 'sourceNetworkObjectUUID', 'name': 'Host1'}]} |
| destinationNetworks | {'objects': [{'type': 'Host', 'id': 'destinationNetworkUUID', 'name': 'Host1'}]} |
| snmpConfig | {'id': 'snmpConfigUuid', 'name': 'snmp_alert1', 'type': 'SNMPAlert'} |
| syslogConfig | {'id': 'syslogConfigUuid', 'name': 'syslog_alert1', 'type': 'SyslogAlert'} |
| newComments | ['comment1', 'comment2'] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Query Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| bulk | False | boolean <td colspan=3> This parameter specifies that bulk operation is being used in the query. This parameter is required for bulk rule operations. |
| insertAfter | False | string <td colspan=3> This parameter specifies that the rules will be inserted after the specified rule index. insertBefore takes precedence over insertAfter - if both are specified, the insertBefore parameter will apply. |
| insertBefore | False | string <td colspan=3> This parameter specifies that the rules will be inserted before the specified rule index. insertBefore takes precedence over insertAfter - if both are specified, the insertBefore parameter will apply. |

## Example
```yaml
- name: Execute 'createMultiplePrefilterRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultiplePrefilterRule"
    data:
        action: "FASTPATH/ANALYZE/BLOCK"
        enabled: True
        type: "PrefilterRule"
        name: "Rule1"
        sendEventsToFMC: False
        ruleType: "PREFILTER"
        bidirectional: False
        logBegin: False
        logEnd: False
        vlanTags: {'objects': [{'type': 'VlanTag', 'name': 'vlan_tag_1', 'id': 'VlanTagUUID1'}, {'type': 'VlanTag', 'name': 'vlan_tag_2', 'id': 'VlanTagUUID2'}]}
        sourceInterfaces: {'objects': [{'name': 'External', 'id': 'SecurityInterfaceUUID', 'type': 'SecurityZone'}]}
        destinationInterfaces: {'objects': [{'name': 'Internal', 'id': 'SecurityInterfaceUUID', 'type': 'SecurityZone'}]}
        sourcePorts: {'objects': [{'type': 'ProtocolPortObject', 'name': 'AOL', 'id': 'ProtocolPortObjectUUID'}]}
        destinationPorts: {'objects': [{'type': 'ProtocolPortObject', 'name': 'Bittorrent', 'id': 'ProtocolPortObjectUUID'}]}
        sourceNetworks: {'objects': [{'type': 'Host', 'id': 'sourceNetworkObjectUUID', 'name': 'Host1'}]}
        destinationNetworks: {'objects': [{'type': 'Host', 'id': 'destinationNetworkUUID', 'name': 'Host1'}]}
        snmpConfig: {'id': 'snmpConfigUuid', 'name': 'snmp_alert1', 'type': 'SNMPAlert'}
        syslogConfig: {'id': 'syslogConfigUuid', 'name': 'syslog_alert1', 'type': 'SyslogAlert'}
        newComments: ['comment1', 'comment2']
    path_params:
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"
    query_params:
        bulk: "{{ bulk }}"
        insertAfter: "{{ insert_after }}"
        insertBefore: "{{ insert_before }}"

```