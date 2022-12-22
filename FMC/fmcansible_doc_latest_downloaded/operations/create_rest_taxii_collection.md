# createRESTTaxiiCollection

The createRESTTaxiiCollection operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/taxiiconfig/collections](/paths//api/fmc_tid/v1/domain/{domain_uuid}/taxiiconfig/collections.md) path.&nbsp;
## Description
**API Operations on Taxii Collection objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| uri | http://hailataxii.com/taxii-discovery-service |
| username | username |
| passwd | password |
| caCert |  |
| clientCert |  |
| clientPrivateKey |  |
| params | {'hostnameVerifier': 'allow_all', 'selfSignedServerCertificate': 'false'} |
| version | 0.1.0 |
| type | source |
| discoveryInfo | [{'collectionPollIntervalInMinutes': 0, 'collectionName': 'DISCOVERY', 'collectionProtocolBinding': 'urn:taxii.mitre.org:protocol:https:1.0', 'collectionAddress': 'http://hailataxii.com:80/taxii-data', 'collectionMessageBinding': '[urn:taxii.mitre.org:message:xml:1.1]', 'collectionContentBinding': '[]', 'type': 'taxii_collections'}, {'collectionPollIntervalInMinutes': 0, 'collectionName': 'COLLECTION_MANAGEMENT', 'collectionProtocolBinding': 'urn:taxii.mitre.org:protocol:https:1.0', 'collectionAddress': 'http://hailataxii.com:80/taxii-data', 'collectionMessageBinding': '[urn:taxii.mitre.org:message:xml:1.1]', 'collectionContentBinding': '[]', 'type': 'taxii_collections'}, {'collectionPollIntervalInMinutes': 0, 'collectionName': 'POLL', 'collectionProtocolBinding': 'urn:taxii.mitre.org:protocol:https:1.0', 'collectionAddress': 'http://hailataxii.com:80/taxii-data', 'collectionMessageBinding': '[urn:taxii.mitre.org:message:xml:1.1]', 'collectionContentBinding': '[]', 'type': 'taxii_collections'}] |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createRESTTaxiiCollection' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createRESTTaxiiCollection"
    data:
        uri: "http://hailataxii.com/taxii-discovery-service"
        username: "username"
        passwd: "password"
        caCert: ""
        clientCert: ""
        clientPrivateKey: ""
        params: {'hostnameVerifier': 'allow_all', 'selfSignedServerCertificate': 'false'}
        version: "0.1.0"
        type: "source"
        discoveryInfo: [{'collectionPollIntervalInMinutes': 0, 'collectionName': 'DISCOVERY', 'collectionProtocolBinding': 'urn:taxii.mitre.org:protocol:https:1.0', 'collectionAddress': 'http://hailataxii.com:80/taxii-data', 'collectionMessageBinding': '[urn:taxii.mitre.org:message:xml:1.1]', 'collectionContentBinding': '[]', 'type': 'taxii_collections'}, {'collectionPollIntervalInMinutes': 0, 'collectionName': 'COLLECTION_MANAGEMENT', 'collectionProtocolBinding': 'urn:taxii.mitre.org:protocol:https:1.0', 'collectionAddress': 'http://hailataxii.com:80/taxii-data', 'collectionMessageBinding': '[urn:taxii.mitre.org:message:xml:1.1]', 'collectionContentBinding': '[]', 'type': 'taxii_collections'}, {'collectionPollIntervalInMinutes': 0, 'collectionName': 'POLL', 'collectionProtocolBinding': 'urn:taxii.mitre.org:protocol:https:1.0', 'collectionAddress': 'http://hailataxii.com:80/taxii-data', 'collectionMessageBinding': '[urn:taxii.mitre.org:message:xml:1.1]', 'collectionContentBinding': '[]', 'type': 'taxii_collections'}]
    path_params:
        domainUUID: "{{ domain_uuid }}"

```