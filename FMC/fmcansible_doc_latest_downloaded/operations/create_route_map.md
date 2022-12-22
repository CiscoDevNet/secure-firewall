# createRouteMap

The createRouteMap operation handles configuration related to [/api/fmc_config/v1/domain/{domainUUID}/object/routemaps](/paths//api/fmc_config/v1/domain/{domain_uuid}/object/routemaps.md) path.&nbsp;
## Description
**Retrieves, deletes, creates or modifies the RouteMap with the specified ID. If no ID is specified, retrieves all RouteMap objects. _Check the response section for applicable examples (if any)._**

## Data Parameters Example
| Parameter | Value |
| --------- | -------- |
| entries | [{'interfaces': [{'name': 'outside', 'id': 'a01a5116-d8fc-11e8-80ae-af460801fbe6', 'type': 'SecurityZone'}], 'ipv4AccessListNextHops': [{'name': 'testSACL', 'id': '00505686-A281-0ed3-0000-094489280517', 'type': 'StandardAccessList'}], 'tagValues': [123], 'ipv4AccessListRouteSources': [{'name': 'testSACL', 'id': '00505686-A281-0ed3-0000-094489280517', 'type': 'StandardAccessList'}], 'ipv6AccessListAddresses': [{'name': 'extACL', 'id': '00505686-A281-0ed3-0000-094489280558', 'type': 'ExtendedAccessList'}], 'ipv6AccessListNextHops': [{'name': 'extACL', 'id': '00505686-A281-0ed3-0000-094489280558', 'type': 'ExtendedAccessList'}], 'ipv6AccessListRouteSources': [{'name': 'extACL', 'id': '00505686-A281-0ed3-0000-094489280558', 'type': 'ExtendedAccessList'}], 'metricRouteValues': [11], 'routeTypeLocal': True, 'ipv4AccessListAddresses': [{'name': 'testSACL', 'id': '00505686-A281-0ed3-0000-094489280517', 'type': 'StandardAccessList'}], 'sequence': 0, 'asPathLists': [{'name': '1', 'id': '00505686-A281-0ed3-0000-103079215107', 'type': 'ASPathList'}], 'extendedCommunityAdditive': True, 'extendedCommunityRouteTarget': '100:100', 'extendedCommunityLists': [{'id': '00505686-E294-0ed3-0000-008589934595', 'type': 'ExtendedCommunityList', 'name': 'ABC'}], 'action': 'PERMIT'}] |
| type | RouteMap |
| name | test |
| overridable | False |
| description |  Created from REST |

## Path Parameters
| Parameter | Required | Type | Description |
| --------- | -------- | ---- | ----------- |
| domainUUID | True | string <td colspan=3> Domain UUID |

## Example
```yaml
- name: Execute 'createRouteMap' operation
  cisco.fmcansible.fmc_configuration:
    operation: "createRouteMap"
    data:
        entries: [{'interfaces': [{'name': 'outside', 'id': 'a01a5116-d8fc-11e8-80ae-af460801fbe6', 'type': 'SecurityZone'}], 'ipv4AccessListNextHops': [{'name': 'testSACL', 'id': '00505686-A281-0ed3-0000-094489280517', 'type': 'StandardAccessList'}], 'tagValues': [123], 'ipv4AccessListRouteSources': [{'name': 'testSACL', 'id': '00505686-A281-0ed3-0000-094489280517', 'type': 'StandardAccessList'}], 'ipv6AccessListAddresses': [{'name': 'extACL', 'id': '00505686-A281-0ed3-0000-094489280558', 'type': 'ExtendedAccessList'}], 'ipv6AccessListNextHops': [{'name': 'extACL', 'id': '00505686-A281-0ed3-0000-094489280558', 'type': 'ExtendedAccessList'}], 'ipv6AccessListRouteSources': [{'name': 'extACL', 'id': '00505686-A281-0ed3-0000-094489280558', 'type': 'ExtendedAccessList'}], 'metricRouteValues': [11], 'routeTypeLocal': True, 'ipv4AccessListAddresses': [{'name': 'testSACL', 'id': '00505686-A281-0ed3-0000-094489280517', 'type': 'StandardAccessList'}], 'sequence': 0, 'asPathLists': [{'name': '1', 'id': '00505686-A281-0ed3-0000-103079215107', 'type': 'ASPathList'}], 'extendedCommunityAdditive': True, 'extendedCommunityRouteTarget': '100:100', 'extendedCommunityLists': [{'id': '00505686-E294-0ed3-0000-008589934595', 'type': 'ExtendedCommunityList', 'name': 'ABC'}], 'action': 'PERMIT'}]
        type: "RouteMap"
        name: "test"
        overridable: False
        description: " Created from REST"
    path_params:
        domainUUID: "{{ domain_uuid }}"

```