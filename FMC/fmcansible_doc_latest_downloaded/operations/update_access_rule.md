# updateAccessRule

The updateAccessRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{containerUUID}/accessrules/{objectId}](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{container_uuid}/accessrules/{object_id}.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the access control rule associated with the specified policy ID and rule ID. If no ID is specified, retrieves list of all access rules associated with the specified policy ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| action | ALLOW |
| enabled | False |
| type | AccessRule |
| name | Rule2 |
| sendEventsToFMC | False |
| id | accessRuleUUID1 |
| vlanTags | {'objects': [{'type': 'VlanTag', 'name': 'vlan_tag_1', 'id': 'VlanTagUUID1'}, {'type': 'VlanTag', 'name': 'vlan_tag_2', 'id': 'VlanTagUUID2'}]} |
| urls | {'urlCategoriesWithReputation': [{'type': 'UrlCategoryAndReputation', 'category': {'name': 'Weapons', 'id': 'URLCategoryUUID', 'type': 'URLCategory'}, 'reputation': 'BENIGN_SITES_WITH_SECURITY_RISKS'}]} |
| sourceZones | {'objects': [{'name': 'External', 'id': 'SecurityZoneUUID', 'type': 'SecurityZone'}]} |
| destinationZones | {'objects': [{'name': 'Internal', 'id': 'SecurityZoneUUID', 'type': 'SecurityZone'}]} |
| sourceDynamicObjects | {'objects': [{'name': 'SourceDynamicObject', 'id': 'dynamicObjectUUID', 'type': 'DynamicObject'}]} |
| destinationDynamicObjects | {'objects': [{'name': 'destinationDynamicObject', 'id': 'dynamicObjectUUID', 'type': 'DynamicObject'}]} |
| logFiles | False |
| logBegin | False |
| logEnd | False |
| variableSet | {'name': 'Default Set', 'id': 'VariableSetUUID', 'type': 'VariableSet'} |
| sourcePorts | {'objects': [{'type': 'ProtocolPortObject', 'name': 'AOL', 'id': 'ProtocolPortObjectUUID'}]} |
| destinationPorts | {'objects': [{'type': 'ProtocolPortObject', 'name': 'Bittorrent', 'id': 'ProtocolPortObjectUUID'}]} |
| ipsPolicy | {'type': 'IntrusionPolicy', 'id': 'ipsPolicyUuid', 'name': 'ipsPlicyName'} |
| filePolicy | {'type': 'FilePolicy', 'id': 'filePolicyUuid', 'name': 'filePolicyName'} |
| snmpConfig | {'id': 'snmpConfigUuid', 'name': 'snmp_alert1', 'type': 'SNMPAlert'} |
| syslogConfig | {'id': 'syslogConfigUuid', 'name': 'syslog_alert1', 'type': 'SyslogAlert'} |
| newComments | ['comment1', 'comment2'] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of an access control rule. |
| containerUUID | True | string <td colspan=3> The container id under which this specific resource is contained. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateAccessRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateAccessRule"
    data:
        action: "ALLOW"
        enabled: False
        type: "AccessRule"
        name: "Rule2"
        sendEventsToFMC: False
        id: "accessRuleUUID1"
        vlanTags: {'objects': [{'type': 'VlanTag', 'name': 'vlan_tag_1', 'id': 'VlanTagUUID1'}, {'type': 'VlanTag', 'name': 'vlan_tag_2', 'id': 'VlanTagUUID2'}]}
        urls: {'urlCategoriesWithReputation': [{'type': 'UrlCategoryAndReputation', 'category': {'name': 'Weapons', 'id': 'URLCategoryUUID', 'type': 'URLCategory'}, 'reputation': 'BENIGN_SITES_WITH_SECURITY_RISKS'}]}
        sourceZones: {'objects': [{'name': 'External', 'id': 'SecurityZoneUUID', 'type': 'SecurityZone'}]}
        destinationZones: {'objects': [{'name': 'Internal', 'id': 'SecurityZoneUUID', 'type': 'SecurityZone'}]}
        sourceDynamicObjects: {'objects': [{'name': 'SourceDynamicObject', 'id': 'dynamicObjectUUID', 'type': 'DynamicObject'}]}
        destinationDynamicObjects: {'objects': [{'name': 'destinationDynamicObject', 'id': 'dynamicObjectUUID', 'type': 'DynamicObject'}]}
        logFiles: False
        logBegin: False
        logEnd: False
        variableSet: {'name': 'Default Set', 'id': 'VariableSetUUID', 'type': 'VariableSet'}
        sourcePorts: {'objects': [{'type': 'ProtocolPortObject', 'name': 'AOL', 'id': 'ProtocolPortObjectUUID'}]}
        destinationPorts: {'objects': [{'type': 'ProtocolPortObject', 'name': 'Bittorrent', 'id': 'ProtocolPortObjectUUID'}]}
        ipsPolicy: {'type': 'IntrusionPolicy', 'id': 'ipsPolicyUuid', 'name': 'ipsPlicyName'}
        filePolicy: {'type': 'FilePolicy', 'id': 'filePolicyUuid', 'name': 'filePolicyName'}
        snmpConfig: {'id': 'snmpConfigUuid', 'name': 'snmp_alert1', 'type': 'SNMPAlert'}
        syslogConfig: {'id': 'syslogConfigUuid', 'name': 'syslog_alert1', 'type': 'SyslogAlert'}
        newComments: ['comment1', 'comment2']
    path_params:
        objectId: "{{ object_id }}"
        containerUUID: "{{ container_uuid }}"
        domainUUID: "{{ domain_uuid }}"

```