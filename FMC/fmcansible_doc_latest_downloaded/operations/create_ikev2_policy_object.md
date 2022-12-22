# createIkev2PolicyObject

The createIkev2PolicyObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ikev2policies](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ikev2policies.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKEv2 object associated with the specified ID. If no ID is specified for a GET, retrieves list of all IKEv2 monitor objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| priority | 12 |
| type | Ikev2Policy |
| lifetimeInSeconds | 86400 |
| encryptionAlgorithms | ['AES-GCM', 'AES-GCM-192', 'AES-GCM-256'] |
| integrityAlgorithms | ['NULL'] |
| prfIntegrityAlgorithms | ['SHA', 'SHA-256', 'SHA-384', 'SHA-512'] |
| diffieHellmanGroups | [5, 14, 19, 20, 21] |
| name | api_ike33 |
| description |   |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createIkev2PolicyObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createIkev2PolicyObject"
    data:
        priority: 12
        type: "Ikev2Policy"
        lifetimeInSeconds: 86400
        encryptionAlgorithms: ['AES-GCM', 'AES-GCM-192', 'AES-GCM-256']
        integrityAlgorithms: ['NULL']
        prfIntegrityAlgorithms: ['SHA', 'SHA-256', 'SHA-384', 'SHA-512']
        diffieHellmanGroups: [5, 14, 19, 20, 21]
        name: "api_ike33"
        description: " "
    path_params:
        domainUUID: "{{ domain_uuid }}"

```