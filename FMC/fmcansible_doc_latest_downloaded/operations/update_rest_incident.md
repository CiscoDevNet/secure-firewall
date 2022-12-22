# updateRESTIncident

The updateRESTIncident operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/incident/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/incident/{object_id}.md) path.&nbsp;
## Description
**API Operations on Incident objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| updatedAt | 1499839877 |
| sourceName | Test STIX Feed |
| equation | {'children': [{'children': [{'isRealized': False, 'type': 'LL_UNSUPPORTED_OBJECT_TYPE|Port', 'value': 'IDREF:{http://hailataxii.com}Observable-fbdadbd3-dc8f-4f21-8736-1123903a056f'}], 'condition': 'EQUALS', 'isRealized': False, 'applyCondition': 'ANY'}, {'children': [{'isRealized': False, 'type': 'LL_UNSUPPORTED_OBJECT_TYPE|Port', 'value': 'IDREF:{http://hailataxii.com}Observable-ffed4f18-a648-4162-a088-a529f218ff96'}], 'condition': 'EQUALS', 'isRealized': False, 'applyCondition': 'ANY'}, {'children': [{'isRealized': False, 'type': 'IPV_4_ADDR', 'value': 'ipAddressValue'}], 'condition': 'EQUALS', 'isRealized': False, 'applyCondition': 'ANY'}, {'children': [{'isRealized': True, 'type': 'DomainNameObjectType', 'value': 'domainNameValue'}], 'condition': 'EQUALS', 'isRealized': True, 'applyCondition': 'ANY'}], 'isRealized': True, 'op': 'OR'} |
| indicatorName | Test Indicators |
| observations | [{'count': 1, 'elementName': 'elementName', 'elementId': 'elementUUID', 'type': 'observation', 'data': {'miscData': {'appId': 'DNS', 'clientId': 'DNS', 'connectionSec': '1498739571', 'counter': '77', 'destIpAddress': 'ipAddressValue', 'destPort': '53', 'destZone': 'AutomatedInlineSZ', 'dnsResponse': 'No Error', 'instanceId': '1', 'protocol': 'UDP', 'srcIpAddress': 'ipAddressValue', 'srcPort': '41207', 'srcZone': 'AutomatedInlineSZ', 'userId': 'No Authentication Required'}, 'actionTaken': 'none', 'type': 'DomainNameObjectType', 'value': 'domainNameValue'}, 'timestamp': 1498739571}] |
| indicatorId | indicatorUUID |
| feedId | feedUUID |
| realizedAt | 1498739604 |
| actionTaken | monitored |
| property | {'ttl': 90, 'allowlist': False, 'expirationTime': 1506514581, 'publish': True, 'action': 'monitor'} |
| status | new |
| id | incidentUUID |
| type | incident |
| version | 1.0.0 |
| name | Incident |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Incident. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateRESTIncident' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateRESTIncident"
    data:
        updatedAt: 1499839877
        sourceName: "Test STIX Feed"
        equation: {'children': [{'children': [{'isRealized': False, 'type': 'LL_UNSUPPORTED_OBJECT_TYPE|Port', 'value': 'IDREF:{http://hailataxii.com}Observable-fbdadbd3-dc8f-4f21-8736-1123903a056f'}], 'condition': 'EQUALS', 'isRealized': False, 'applyCondition': 'ANY'}, {'children': [{'isRealized': False, 'type': 'LL_UNSUPPORTED_OBJECT_TYPE|Port', 'value': 'IDREF:{http://hailataxii.com}Observable-ffed4f18-a648-4162-a088-a529f218ff96'}], 'condition': 'EQUALS', 'isRealized': False, 'applyCondition': 'ANY'}, {'children': [{'isRealized': False, 'type': 'IPV_4_ADDR', 'value': 'ipAddressValue'}], 'condition': 'EQUALS', 'isRealized': False, 'applyCondition': 'ANY'}, {'children': [{'isRealized': True, 'type': 'DomainNameObjectType', 'value': 'domainNameValue'}], 'condition': 'EQUALS', 'isRealized': True, 'applyCondition': 'ANY'}], 'isRealized': True, 'op': 'OR'}
        indicatorName: "Test Indicators"
        observations: [{'count': 1, 'elementName': 'elementName', 'elementId': 'elementUUID', 'type': 'observation', 'data': {'miscData': {'appId': 'DNS', 'clientId': 'DNS', 'connectionSec': '1498739571', 'counter': '77', 'destIpAddress': 'ipAddressValue', 'destPort': '53', 'destZone': 'AutomatedInlineSZ', 'dnsResponse': 'No Error', 'instanceId': '1', 'protocol': 'UDP', 'srcIpAddress': 'ipAddressValue', 'srcPort': '41207', 'srcZone': 'AutomatedInlineSZ', 'userId': 'No Authentication Required'}, 'actionTaken': 'none', 'type': 'DomainNameObjectType', 'value': 'domainNameValue'}, 'timestamp': 1498739571}]
        indicatorId: "indicatorUUID"
        feedId: "feedUUID"
        realizedAt: 1498739604
        actionTaken: "monitored"
        property: {'ttl': 90, 'allowlist': False, 'expirationTime': 1506514581, 'publish': True, 'action': 'monitor'}
        status: "new"
        id: "incidentUUID"
        type: "incident"
        version: "1.0.0"
        name: "Incident"
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```