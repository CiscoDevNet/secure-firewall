# createIkev1PolicyObject

The createIkev1PolicyObject operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/ikev1policies](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/ikev1policies.md) path.&nbsp;
## Description
**Retrieves, deletes, creates, or modifies the IKEv1 policy object associated with the specified ID. If no ID is specified for a GET, retrieves list of all IKEv1 policy objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| name | ikev1policy-test-1 |
| priority | 20 |
| lifetimeInSeconds | 86400 |
| diffieHellmanGroup | 5 |
| authenticationMethod | Preshared Key |
| encryption | AES-128 |
| hash | SHA |
| type | IKEv1Policy |
| description | IKEv1 Policy object description |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createIkev1PolicyObject' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createIkev1PolicyObject"
    data:
        name: "ikev1policy-test-1"
        priority: 20
        lifetimeInSeconds: 86400
        diffieHellmanGroup: 5
        authenticationMethod: "Preshared Key"
        encryption: "AES-128"
        hash: "SHA"
        type: "IKEv1Policy"
        description: "IKEv1 Policy object description"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```