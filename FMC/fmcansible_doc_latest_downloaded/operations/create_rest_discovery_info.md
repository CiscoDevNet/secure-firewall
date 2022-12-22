# createRESTDiscoveryInfo

The createRESTDiscoveryInfo operation handles configuration related to [/api/fmc_tid/v1/domain/{domainUUID}/taxiiconfig/discoveryinfo](/paths//api/fmc_tid/v1/domain/{domain_uuid}/taxiiconfig/discoveryinfo.md) path.&nbsp;
## Description
**API Operations on Discovery Info objects. _Check the response section for applicable examples (if any)._**

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

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createRESTDiscoveryInfo' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createRESTDiscoveryInfo"
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
    path_params:
        domainUUID: "{{ domain_uuid }}"

```