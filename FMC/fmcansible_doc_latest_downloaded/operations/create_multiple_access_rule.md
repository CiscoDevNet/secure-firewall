# createMultipleAccessRule

The createMultipleAccessRule operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/policy/accesspolicies/{containerUUID}/accessrules](/paths//api/fmc_config/v1/domain/{domain_uuid}/policy/accesspolicies/{container_uuid}/accessrules.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the access control rule associated with the specified policy ID and rule ID. If no ID is specified, retrieves list of all access rules associated with the specified policy ID. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| action | ALLOW |
| enabled | True |
| type | AccessRule |
| name | Rule1 |
| sendEventsToFMC | False |
| logFiles | False |
| logBegin | False |
| logEnd | False |
| variableSet | {'name': 'Default Set', 'id': 'VariableSetUUID', 'type': 'VariableSet'} |
| vlanTags | {'objects': [{'type': 'VlanTag', 'name': 'vlan_tag_1', 'id': 'VlanTagUUID1'}, {'type': 'VlanTag', 'name': 'vlan_tag_2', 'id': 'VlanTagUUID2'}]} |
| urls | {'urlCategoriesWithReputation': [{'type': 'UrlCategoryAndReputation', 'category': {'name': 'Weapons', 'id': 'URLCategoryUUID', 'type': 'URLCategory'}, 'reputation': 'BENIGN_SITES_WITH_SECURITY_RISKS'}]} |
| sourceZones | {'objects': [{'name': 'External', 'id': 'SecurityZoneUUID', 'type': 'SecurityZone'}]} |
| destinationZones | {'objects': [{'name': 'Internal', 'id': 'SecurityZoneUUID', 'type': 'SecurityZone'}]} |
| sourcePorts | {'objects': [{'type': 'ProtocolPortObject', 'name': 'AOL', 'id': 'ProtocolPortObjectUUID'}]} |
| sourceDynamicObjects | {'objects': [{'name': 'SourceDynamicObject', 'id': 'dynamicObjectUUID', 'type': 'DynamicObject'}]} |
| destinationDynamicObjects | {'objects': [{'name': 'destinationDynamicObject', 'id': 'dynamicObjectUUID', 'type': 'DynamicObject'}]} |
| destinationPorts | {'objects': [{'type': 'ProtocolPortObject', 'name': 'Bittorrent', 'id': 'ProtocolPortObjectUUID'}]} |
| ipsPolicy | {'type': 'IntrusionPolicy', 'id': 'ipsPolicyUuid', 'name': 'ipsPlicyName'} |
| filePolicy | {'type': 'FilePolicy', 'id': 'filePolicyUuid', 'name': 'filePolicyName'} |
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
| insertAfter | False | string <td colspan=3> This parameter specifies that the rules will be inserted after the specified rule index. If no section or category is specified, the rules will be added to the section or category after the insertion point. insertBefore takes precedence over insertAfter - if both are specified, the insertBefore parameter will apply. |
| insertBefore | False | string <td colspan=3> This parameter specifies that the rules will be inserted before the specified rule index. If no section or category is specified, the rules will be added to the section or category before the insertion point. insertBefore takes precedence over insertAfter - if both are specified, the insertBefore parameter will apply. |
| section | False | string <td colspan=3> This parameter specifies the section into which the rules will be added. If this parameter is not used the section will be the default section. Only 'mandatory' and 'default' are allowed values. If a section is specified, a category cannot be specified. |
| category | False | string <td colspan=3> This parameter specifies the category into which the rules will be added. If a category is specified it must exist or the request will fail. If a section is specified, a category cannot be specified. |

## Example
```yaml
- name: Execute 'createMultipleAccessRule' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createMultipleAccessRule"
    data:
        action: "ALLOW"
        enabled: True
        type: "AccessRule"
        name: "Rule1"
        sendEventsToFMC: False
        logFiles: False
        logBegin: False
        logEnd: False
        variableSet: {'name': 'Default Set', 'id': 'VariableSetUUID', 'type': 'VariableSet'}
        vlanTags: {'objects': [{'type': 'VlanTag', 'name': 'vlan_tag_1', 'id': 'VlanTagUUID1'}, {'type': 'VlanTag', 'name': 'vlan_tag_2', 'id': 'VlanTagUUID2'}]}
        urls: {'urlCategoriesWithReputation': [{'type': 'UrlCategoryAndReputation', 'category': {'name': 'Weapons', 'id': 'URLCategoryUUID', 'type': 'URLCategory'}, 'reputation': 'BENIGN_SITES_WITH_SECURITY_RISKS'}]}
        sourceZones: {'objects': [{'name': 'External', 'id': 'SecurityZoneUUID', 'type': 'SecurityZone'}]}
        destinationZones: {'objects': [{'name': 'Internal', 'id': 'SecurityZoneUUID', 'type': 'SecurityZone'}]}
        sourcePorts: {'objects': [{'type': 'ProtocolPortObject', 'name': 'AOL', 'id': 'ProtocolPortObjectUUID'}]}
        sourceDynamicObjects: {'objects': [{'name': 'SourceDynamicObject', 'id': 'dynamicObjectUUID', 'type': 'DynamicObject'}]}
        destinationDynamicObjects: {'objects': [{'name': 'destinationDynamicObject', 'id': 'dynamicObjectUUID', 'type': 'DynamicObject'}]}
        destinationPorts: {'objects': [{'type': 'ProtocolPortObject', 'name': 'Bittorrent', 'id': 'ProtocolPortObjectUUID'}]}
        ipsPolicy: {'type': 'IntrusionPolicy', 'id': 'ipsPolicyUuid', 'name': 'ipsPlicyName'}
        filePolicy: {'type': 'FilePolicy', 'id': 'filePolicyUuid', 'name': 'filePolicyName'}
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
        section: "{{ section }}"
        category: "{{ category }}"

```