# Introduction to Ansible modules for FMC REST API

A collection of Ansible modules that automate provisioning, configuration management and execution of operational tasks on
Cisco Firepower Threat Defense (FTD) devices. Currently, four Ansible modules are available:

* [`fmc_configuration`] - manages device configuration via REST API. The module configures virtual and physical devices by sending HTTPS calls formatted according to the REST API specification;


### How to use Ansible modules

A simple example of creating a network with the [`fmc_configuration`](../operations/create_access_policy_category.md) module looks like this.

Check out the [Examples](../samples) section for more playbook samples.