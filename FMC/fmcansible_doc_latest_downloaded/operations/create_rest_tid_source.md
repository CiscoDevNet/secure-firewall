# createRESTTidSource

The createRESTTidSource operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/source](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/source.md) path.&nbsp;
## Description
**API Operations on Source objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| startHour | 2 |
| name | Sample TAXII Feed |
| description | Sample TAXII Feed |
| feedType | stix |
| feedContent | stix |
| delivery | taxii |
| uri | http://hailataxii.com/taxii-discovery-service |
| username | username |
| passwd | password |
| refresh | 1440 |
| version | 1.0.0 |
| downloadOn | True |
| subscribedCollections | [{'collectionPollIntervalInMinutes': 0, 'collectionName': 'guest.MalwareDomainList_Hostlist', 'collectionDescription': 'guest.MalwareDomainList_Hostlist', 'collectionProtocolBinding': 'urn:taxii.mitre.org:protocol:https:1.0', 'collectionAddress': 'http://hailataxii.com:80/taxii-data', 'collectionMessageBinding': '[urn:taxii.mitre.org:message:xml:1.1]', 'type': 'taxii_collections'}] |
| params | {'selfSignedServerCertificate': 'false', 'hostnameVerifier': 'allow_all'} |
| property | {'ttl': 90, 'publish': True, 'action': 'monitor'} |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createRESTTidSource' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createRESTTidSource"
    data:
        startHour: 2
        name: "Sample TAXII Feed"
        description: "Sample TAXII Feed"
        feedType: "stix"
        feedContent: "stix"
        delivery: "taxii"
        uri: "http://hailataxii.com/taxii-discovery-service"
        username: "username"
        passwd: "password"
        refresh: 1440
        version: "1.0.0"
        downloadOn: True
        subscribedCollections: [{'collectionPollIntervalInMinutes': 0, 'collectionName': 'guest.MalwareDomainList_Hostlist', 'collectionDescription': 'guest.MalwareDomainList_Hostlist', 'collectionProtocolBinding': 'urn:taxii.mitre.org:protocol:https:1.0', 'collectionAddress': 'http://hailataxii.com:80/taxii-data', 'collectionMessageBinding': '[urn:taxii.mitre.org:message:xml:1.1]', 'type': 'taxii_collections'}]
        params: {'selfSignedServerCertificate': 'false', 'hostnameVerifier': 'allow_all'}
        property: {'ttl': 90, 'publish': True, 'action': 'monitor'}
    path_params:
        domainUUID: "{{ domain_uuid }}"

```