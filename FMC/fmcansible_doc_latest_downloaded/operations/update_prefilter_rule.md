# updatePrefilterRule

The updatePrefilterRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/prefilterpolicies/{containerUUID}/prefilterrules/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/prefilterpolicies/{container_uuid}/prefilterrules/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the prefilter rule associated with the specified policy ID and rule ID. If no ID is specified, retrieves list of all prefilter rules associated with the specified policy ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| action | FASTPATH/ANALYZE/BLOCK |
| enabled | False |
| type | PrefilterRule |
| name | Rule2 |
| sendEventsToFMC | False |
| ruleType | PREFILTER |
| bidirectional | False |
| id | prefilterruleUUID1 |
| vlanTags | {'objects': [{'type': 'VlanTag', 'name': 'vlan_tag_1', 'id': 'VlanTagUUID1'}, {'type': 'VlanTag', 'name': 'vlan_tag_2', 'id': 'VlanTagUUID2'}]} |
| sourceInterfaces | {'objects': [{'name': 'External', 'id': 'SecurityInterfaceUUID', 'type': 'SecurityZone'}]} |
| destinationInterfaces | {'objects': [{'name': 'Internal', 'id': 'SecurityInterfaceUUID', 'type': 'SecurityZone'}]} |
| sourceNetworks | {'objects': [{'type': 'Host', 'id': 'sourceNetworkObjectUUID', 'name': 'Host1'}]} |
| destinationNetworks | {'objects': [{'type': 'Host', 'id': 'destinationNetworkUUID', 'name': 'Host1'}]} |
| logBegin | False |
| logEnd | False |
| sourcePorts | {'objects': [{'type': 'ProtocolPortObject', 'name': 'AOL', 'id': 'ProtocolPortObjectUUID'}]} |
| destinationPorts | {'objects': [{'type': 'ProtocolPortObject', 'name': 'Bittorrent', 'id': 'ProtocolPortObjectUUID'}]} |
| timeRangeObjects | [{'type': 'TimeRange', 'name': 'TestTimeRange', 'id': 'TimeRangeUUID'}] |
| snmpConfig | {'id': 'snmpConfigUuid', 'name': 'snmp_alert1', 'type': 'SNMPAlert'} |
| syslogConfig | {'id': 'syslogConfigUuid', 'name': 'syslog_alert1', 'type': 'SyslogAlert'} |
| newComments | ['comment1', 'comment2'] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of a prefilter rule. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updatePrefilterRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updatePrefilterRule"
    data:
        action: "FASTPATH/ANALYZE/BLOCK"
        enabled: False
        type: "PrefilterRule"
        name: "Rule2"
        sendEventsToFMC: False
        ruleType: "PREFILTER"
        bidirectional: False
        id: "prefilterruleUUID1"
        vlanTags: {'objects': [{'type': 'VlanTag', 'name': 'vlan_tag_1', 'id': 'VlanTagUUID1'}, {'type': 'VlanTag', 'name': 'vlan_tag_2', 'id': 'VlanTagUUID2'}]}
        sourceInterfaces: {'objects': [{'name': 'External', 'id': 'SecurityInterfaceUUID', 'type': 'SecurityZone'}]}
        destinationInterfaces: {'objects': [{'name': 'Internal', 'id': 'SecurityInterfaceUUID', 'type': 'SecurityZone'}]}
        sourceNetworks: {'objects': [{'type': 'Host', 'id': 'sourceNetworkObjectUUID', 'name': 'Host1'}]}
        destinationNetworks: {'objects': [{'type': 'Host', 'id': 'destinationNetworkUUID', 'name': 'Host1'}]}
        logBegin: False
        logEnd: False
        sourcePorts: {'objects': [{'type': 'ProtocolPortObject', 'name': 'AOL', 'id': 'ProtocolPortObjectUUID'}]}
        destinationPorts: {'objects': [{'type': 'ProtocolPortObject', 'name': 'Bittorrent', 'id': 'ProtocolPortObjectUUID'}]}
        timeRangeObjects: [{'type': 'TimeRange', 'name': 'TestTimeRange', 'id': 'TimeRangeUUID'}]
        snmpConfig: {'id': 'snmpConfigUuid', 'name': 'snmp_alert1', 'type': 'SNMPAlert'}
        syslogConfig: {'id': 'syslogConfigUuid', 'name': 'syslog_alert1', 'type': 'SyslogAlert'}
        newComments: ['comment1', 'comment2']
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```