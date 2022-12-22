# createSnort3IPSRulesFileUpload

The createSnort3IPSRulesFileUpload operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/intrusionrulesupload](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/intrusionrulesupload.md) path.&nbsp;
## Description
**Imports custom Snort 3 intrusion rules. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| payloadFile | .rules or .txt format Snort3 rule file |
| ruleGroups | group-id1,group-id2,group-id3 |
| validateOnly | TRUE or FALSE |
| ruleImportMode | ENUM (MERGE, REPLACE) |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createSnort3IPSRulesFileUpload' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createSnort3IPSRulesFileUpload"
    data:
        payloadFile: ".rules or .txt format Snort3 rule file"
        ruleGroups: "group-id1,group-id2,group-id3"
        validateOnly: "TRUE or FALSE"
        ruleImportMode: "ENUM (MERGE, REPLACE)"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```