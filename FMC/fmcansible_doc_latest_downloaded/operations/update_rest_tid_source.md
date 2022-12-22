# updateRESTTidSource

The updateRESTTidSource operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/tid/source/{objectId}](/paths//api/fmc_tid/v1/domain/{domain_uuid}/tid/source/{object_id}.md) path.&nbsp;
## Description
**API Operations on Source objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| uri | http://somehost/feeds/domain.txt |
| params | {'selfSignedServerCertificate': 'false', 'hostnameVerifier': 'allow_all'} |
| nextRun | 1499922000 |
| consumedUnsupportedObservables | 0 |
| checksum | 6A330EFFD42314B74C030C0038BAB3352F70CC5344D6CE24774BD04EFDEDB7BD |
| lastRun | 1499836832 |
| totalUnsupportedObservables | 0 |
| totalInvalidObservables | 0 |
| downloadOn | True |
| runNow | False |
| feedStatus | parsing |
| consumedIndicators | 0 |
| totalIndicators | 0 |
| discardedIndicators | 0 |
| totalDiscardedIndicators | 0 |
| totalObservables | 0 |
| invalidObservables | 0 |
| consumedObservables | 501 |
| feedType | flatfile |
| feedContent | DomainNameObjectType |
| delivery | url |
| refresh | 1440 |
| property | {'ttl': '80', 'publish': True, 'action': 'block'} |
| id | sourceUUID |
| type | source |
| name | Test URL Source |
| description | Test URL Source |
| caCert |  |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| objectId | True | string <td colspan=3> Unique identifier of the Source. |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'updateRESTTidSource' operation
  cisco.fmcansible.fmc_configuration:
    operation: "updateRESTTidSource"
    data:
        uri: "http://somehost/feeds/domain.txt"
        params: {'selfSignedServerCertificate': 'false', 'hostnameVerifier': 'allow_all'}
        nextRun: 1499922000
        consumedUnsupportedObservables: 0
        checksum: "6A330EFFD42314B74C030C0038BAB3352F70CC5344D6CE24774BD04EFDEDB7BD"
        lastRun: 1499836832
        totalUnsupportedObservables: 0
        totalInvalidObservables: 0
        downloadOn: True
        runNow: False
        feedStatus: "parsing"
        consumedIndicators: 0
        totalIndicators: 0
        discardedIndicators: 0
        totalDiscardedIndicators: 0
        totalObservables: 0
        invalidObservables: 0
        consumedObservables: 501
        feedType: "flatfile"
        feedContent: "DomainNameObjectType"
        delivery: "url"
        refresh: 1440
        property: {'ttl': '80', 'publish': True, 'action': 'block'}
        id: "sourceUUID"
        type: "source"
        name: "Test URL Source"
        description: "Test URL Source"
        caCert: ""
    path_params:
        objectId: "{{ object_id }}"
        domainUUID: "{{ domain_uuid }}"

```