
# Cisco Secure Firewall Management Center (FMC) Ansible Collection

This ansible collection automates configuration management and execution of operational tasks on Cisco Secure Firewall Threat Defence (FTD) being managed by Firewall Management Center (FMC) using ansible.

fmc_Configuration module – this module will be used to configure and manage FTD devices that are being managed by an FMC. FMC REST API will be used to communicate with the device by sending HTTPS calls formatted according to the REST API specification.

This module allows executing all operations available in REST API in a form of Ansible tasks. Each REST API endpoint can be wrapped into an Ansible play and be a part of a playbook.

A detailed list of supported API calls can be found on the api-explorer page of the FMC

How to use:

## **Creating Inventory**

Ansible inventory contains information about systems where the playbooks should be run. You should create an inventory file with information about the FMC that will be used for configuration.

The default location for inventory is /etc/ansible/hosts, but you can specify a different path by adding the `-i <path>` argument to the ansible-playbook command.

The inventory file requires:

-       Hostname or IP Address of the FMC

-       Username for FMC

-       Password for the given user

```
[all:vars]
ansible_network_os=cisco.fmcansible.fmc

[vfmc]
192.168.1.1 ansible_user=user ansible_password=password ansible_httpapi_port=443 ansible_httpapi_use_ssl=True ansible_httpapi_validate_certs=False

[vfmc:vars]
network_type=HOST
```

---

### **Task Operations**

Most operations are similar to CRUD functions and can be divided into the following groups:

**Get** - fetches an object by its ID

**getAll** - fetches a list of objects matching given criteria

**create** - creates a new object

**createMultiple** - creates multiple new objects

**update** - updates an existing object

**delete** - deletes an existing object by its ID

**upsert** - creates a new object if it does not exist, or updates it when the object already exists

---

### **Task Parameters**

| **Parameter**    | **Required** | **Type** | **Description**                                                                                                                                                      |
| ---------------- | :------------: | :--------: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **operation**    | True         | string   | The name of the operation to execute. Commonly, the operation starts with 'create', 'update', 'get', 'upsert' or 'delete' verbs, but can have an arbitrary name too. |
| **data**         | False        | dict     | Corresponds to the body part in HTTP request and is mandatory for create, update and upsert operations.                                                              |
| **query_params** | False        | dict     | Corresponds to the query string in HTTP request                                                                                                                      |
| **path_params**  | False        | dict     | Corresponds to URL parameters in HTTP request                                                                                                                        |
| **register_as**  | False        | string   | A name for the fact that is registered with the response from the server.                                                                                            |
| **filters**      | False        | dict     | A map with filter criteria for upsert and getAll operations.                                                                                                         |
### **Return** **Value**

| **Value**    | **Returned** | **Type** | **Description**                           |
| ------------ | ------------ | :--------: | ----------------------------------------- |
| **response** | Success      | dict     | HTTP response returned from the API call. |

### **Server Response**

The module registers server response as ansible_facts to be used in the playbook as
regular variables.

By default, fact names are constructed as {OBJECT_TYPE} _{LOWERCASE_OBJECT_NAME}

If you want to change the default naming convention, add a register_as parameter with the desired fact name to the play.

> For a network object created by the ansible module named **test_network**, the ansible_facts name will be **Network_test_network**

---

### **Upsert Operation**

Upsert is an idempotent "Insert or Update" operation. It allows defining the desired state of the record instead of checking whether the record exists (and should be updated) or not (and should be created).

Upsert operation uses filters to look for a record on the device and define if the object already exists or not. Default filtering is done by name, and the object has a name as in the data parameter is sought.

In this example, if the network object ansible-test-network does not exist, it will be created with the mentioned value and if the object with this name exists then it will be updated with the mentioned values.

```ansible
- hosts: all
  connection: httpapi
  tasks:
    - name: Get Domain
      cisco.fmcansible.fmc_configuration:
        operation: getAllDomain
        register_as: domain

    - name: upsertNetworkObject should create a new network
      cisco.fmcansible.fmc_configuration:
        operation: upsertNetworkObject
        path_params:
          domainUUID: '{{ getAllDomain[0].uuid }}'
        data:
          name: "ansible-test-network"
          description: "Upserted network object"
          value: "192.23.23.0/24"
          type: "networkobject"
        register_as: "upsertedTestObj"
```
### Registering objects as Ansible facts

In order to reuse objects in subsequent plays during an ansible-playbook run, they should be registered as variables.
FMC module automatically register server responses as Ansible _facts_. Then, these _facts_ can be used in the playbook as
regular variables.

By default, fact names are constructed as `{OBJECT_TYPE}_{LOWERCASE_OBJECT_NAME}`. For example, a `createMultipleNetworkObject`
play creating a `NetworkObject` named `LocalhostNetwork` registers the newly created object in a
`Network_localhostnetwork` fact.

If you want to change the default naming convention, add a `register_as` parameter with the desired fact name to the play.

### Task idempotency

A task is _idempotent_ if the result of running it once is exactly the same as the result of running it
multiple times. As Ansible requires modules to be idempotent, `fmc_configuration` complies with this requirement.

Before executing the operation, fmc_configuration` checks whether the desired final state is already achieved.
If yes, no actions are executed, and the operation finishes showing that the state is not changed. A comparison of objects is described below.

For example, when running the `createMultipleNetworkObject` operation multiple times without changing the play configuration, only the first run results in `changed` status. Subsequent runs are finished with `ok` status.

---

## **Examples**

- ### Create a Network Object

This example demonstrates how to create a simple entity representing a network -
`NetworkObject`. The task creates a new object representing the subnet.

After creation, the network object is stored as an Ansible fact and can be accessed
using `Network_net15` variable.

```ansible
- hosts: all
  connection: httpapi
  tasks:
    - name: Get Domain UUID
      cisco.fmcansible.fmc_configuration:
        operation: getAllDomain
        register_as: domain

    - name: Create a network object for Cisco FTD 1
      cisco.fmcansible.fmc_configuration:
        operation: createMultipleNetworkObject
        data:
          name: net15
          value: 10.10.30.0/24
          type: Network
        path_params:
          domainUUID: '{{ domain[0].uuid }}'
```

- ### Deploy configuration from FMC to the FTD device

Changes made on the FTD devices are applied only after they get deployed. This example demonstrates
how to start a deployment job and make sure that it succeeds.

The first two tasks fetch a list of pending changes that are not in the deployed state yet and make sure that there are at least
some changes that need to be deployed. Otherwise, the playbook execution stops.

```ansible
- hosts: all
  connection: httpapi
  tasks:
    - name: Get Domain
      cisco.fmcansible.fmc_configuration:
        operation: getAllDomain
        register_as: domain

    - name: Get Deployable Devices
      cisco.fmcansible.fmc_configuration:
        operation: getDeployableDevice
        path_params:
          domainUUID: '{{ domain[0].uuid }}'
        query_params:
          expanded: true
        register_as: devices

    - name: Complete playbook when nothing to deploy
      meta: end_play
      when: devices[0].device is undefined

    - name: Fetch pending changes
      cisco.fmcansible.fmc_configuration:
        operation: getPendingChanges
        path_params:
          containerUUID: '{{ devices[0].device.id }}'
          domainUUID: '{{ domain[0].uuid }}'
        register_as: pending_changes

    - name: Start deployment
      cisco.fmcansible.fmc_configuration:
        operation: createDeploymentRequest
        data:
          version: '{{ devices[0].version }}'
          deviceList:
            - '{{ devices[0].device.id }}'
          forceDeploy: True
        path_params:
          domainUUID: '{{ domain[0].uuid }}'
        register_as: deployment_job

    - name: Poll deployment status until the job is finished
      cisco.fmcansible.fmc_configuration:
        operation: getDeploymentDetail
        path_params:
          containerUUID: '{{ devices[0].device.id }}'
          domainUUID: '{{ domain[0].uuid }}'
        register_as: deployment_status
      until: deployment_status[0].status is match("SUCCEEDED")
      retries: 100
      delay: 3

    - name: Stop the playbook if the deployment failed
      fail:
        msg: 'Deployment failed. Status: {{ deployment_status[0].status }}'
      when: deployment_status[0].status is not match("SUCCEEDED")
```

- ### Create Network Group

This example demonstrates how to create a network object group -
`CreateMultipleNetworkGroup`. The task creates a new objects representing the subnets and groups them.


```ansible
- hosts: all
  connection: httpapi
  tasks:
    - name: Get Domain UUID
      cisco.fmcansible.fmc_configuration:
        operation: getAllDomain
        register_as: domain

    - name: Create a network object for Cisco FTD 1
      cisco.fmcansible.fmc_configuration:
        operation: upsertNetworkObject
        #operation: createMultipleNetworkObject
        #operation: updateNetworkObject
        data:
          name: net-15
          value: 10.10.30.0/24
          type: Network
        path_params:
          domainUUID: '{{ domain[0].uuid }}'

    - name: Create a network object for Cisco FTD 2
      cisco.fmcansible.fmc_configuration:
        operation: upsertNetworkObject
        #operation: createMultipleNetworkObject
        #operation: updateNetworkObject
        data:
          name: net-13
          value: 10.10.40.0/24
          type: Network
        path_params:
          domainUUID: '{{ domain[0].uuid }}'

    - name: Create a Cisco network group
      cisco.fmcansible.fmc_configuration:
        operation: createMultipleNetworkGroup
        data:
          name: netg-1
          type: networkgroup
          objects:
            - id: '{{ Network_net_15.id }}'
              type: '{{ Network_net_15.type }}'
            - id: '{{ Network_net_13.id }}'
              type: '{{ Network_net_13.type }}'
        path_params:
          domainUUID: '{{ domain[0].uuid }}'
```

- ### Create Access Rule

An AccessRule permits or denies traffic based on different parameters, such as a protocol,
a source or destination IP address, network, etc.

The example shows how to create an AccessRule allowing traffic from a given source network

```ansible
- hosts: all
  connection: httpapi
  tasks:
    - name: Get Domain
      cisco.fmcansible.fmc_configuration:
        operation: getAllDomain
        register_as: domain

    - name: create auxilary network object
      cisco.fmcansible.fmc_configuration:
        operation: createMultipleNetworkObject
        path_params:
          domainUUID: '{{ domain[0].uuid }}'
        data:
          name: "ansible-test-network466"
          value: "192.22.22.0/24"
          type: "networkobject"
        register_as: net1

    - name: Get Access Policy
      cisco.fmcansible.fmc_configuration:
        operation: getAllAccessPolicy
        path_params:
          domainUUID: '{{ domain[0].uuid }}'
        filters:
          name: NGFW-Access-Policy25
        register_as: accesspolicy

    - name: Create an access rule allowing trafic from Cisco DevNet
      cisco.fmcansible.fmc_configuration:
        operation: upsertAccessRule
        data:
          name: AllowCiscoTraffic8
          type: accessrule
          sourceNetworks:
            objects:
              - id: '{{ net1.id }}'
                name: '{{net1.name }}'
                type: '{{ net1.type }}'
          action: ALLOW
        path_params:
          containerUUID: '{{ accesspolicy[0].id }}'
          domainUUID: '{{ domain[0].uuid }}'
```

- ### Get a Network Object from FMC

This example demonstartes how to query newtwork object using filters

```ansible
- hosts: all
  connection: httpapi
  tasks:
    - name: Get Domain
      cisco.fmcansible.fmc_configuration:
        operation: getAllDomain
        register_as: domain

    - name: Get a specific Network object
      cisco.fmcansible.fmc_configuration:
        operation: getAllNetworkObject
        path_params:
          domainUUID: '{{ domain[0].uuid }}'
        query_params:
          filter: "nameOrValue:test-network4"
```

- ### Delete Network Object

```ansible
- hosts: all
  connection: httpapi
  tasks:
    - name: Get Domain
      cisco.fmcansible.fmc_configuration:
        operation: getAllDomain
        register_as: domain

    - name: Delete created Network Object
      cisco.fmcansible.fmc_configuration:
        operation: deleteNetworkObject
        path_params:
          domainUUID: '{{ domain[0].uuid }}'
          objectId: "{{ test_network.id }}"
```

## **Known issues/limitations**

* Some endpoints use 'name' vs others that use 'nameOrValue'
 For example: /object/networks?filter=nameOrValue:ansible-test
* if description parameter is specified for the security zone object ansible will return **"changed"** on each run even if values are not changed.
* Inconsistent error message and HTTP status for duplicate object error in some cases
