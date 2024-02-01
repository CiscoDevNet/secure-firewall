# DEVWKS-2984 Manage FTDv and FMCv with Ansible

## Setting up the environment
First let's navigate to the directory where all your files and scripts have been pre-created, replace podXX with your assigned pod number.

```commandline
cd /home/devnet/workshop/DEVWKS-2984/podXX/
```

Ensure that Ansible is installed.

```commandline
ansible --version
```

You should get something similar to:

```commandline
ansible [core 2.16.1]
  config file = None
  configured module search path = ['/Users/jwittock/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/Cellar/ansible/9.1.0/libexec/lib/python3.12/site-packages/ansible
  ansible collection location = /Users/jwittock/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.12.1 (main, Dec  7 2023, 20:45:44) [Clang 15.0.0 (clang-1500.1.0.2.5)] (/usr/local/Cellar/ansible/9.1.0/libexec/bin/python)
  jinja version = 3.1.3
  libyaml = True
```

Next we need to install the Cisco FMC Ansible collection. You can do this as follows:
```commandline
ansible-galaxy collection install cisco.fmcansible
```

If it was installed already, you should get something like:

```commandline
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Skipping 'cisco.fmcansible' as it is already installed
```

If it was not yet installed, it would look something like:
```
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'cisco.fmcansible:0.9.0' to '/home/jwittock/.ansible/collections/ansible_collections/cisco/fmcansible'
Downloading https://galaxy.ansible.com/download/cisco-fmcansible-0.9.0.tar.gz to /home/jwittock/.ansible/tmp/ansible-local-2881498es41d_5d/tmp7u31fr1h
cisco.fmcansible (0.9.0) was installed successfully
Installing 'ansible.utils:2.6.1' to '/home/jwittock/.ansible/collections/ansible_collections/ansible/utils'
Downloading https://galaxy.ansible.com/download/ansible-utils-2.6.1.tar.gz to /home/jwittock/.ansible/tmp/ansible-local-2881498es41d_5d/tmp7u31fr1h
ansible.utils (2.6.1) was installed successfully
Installing 'ansible.netcommon:3.0.1' to '/home/jwittock/.ansible/collections/ansible_collections/ansible/netcommon'
Downloading https://galaxy.ansible.com/download/ansible-netcommon-3.0.1.tar.gz to /home/jwittock/.ansible/tmp/ansible-local-2881498es41d_5d/tmp7u31fr1h
ansible.netcommon (3.0.1) was installed successfully
Installing 'community.general:3.8.0' to '/home/jwittock/.ansible/collections/ansible_collections/community/general'
Downloading https://galaxy.ansible.com/download/community-general-3.8.0.tar.gz to /home/jwittock/.ansible/tmp/ansible-local-2881498es41d_5d/tmp7u31fr1h
community.general (3.8.0) was installed successfully
Installing 'community.network:3.0.0' to '/home/jwittock/.ansible/collections/ansible_collections/community/network'
Downloading https://galaxy.ansible.com/download/community-network-3.0.0.tar.gz to /home/jwittock/.ansible/tmp/ansible-local-2881498es41d_5d/tmp7u31fr1h
community.network (3.0.0) was installed successfully
```


This is the directory where the playbooks you will use are located.

## Task 01: Create an Inventory

Open the inventory file named `hosts` and ensure there is an FMC ip address, username and password.
    ```
    [all:vars]
    ansible_network_os=cisco.fmcansible.fmc

    [vfmc]
    172.16.0.1 ansible_user=devnet-u01 ansible_password=Password@123 ansible_httpapi_port=443 ansible_httpapi_use_ssl=True ansible_httpapi_validate_certs=False

    [vfmc:vars]
    network_type=HOST
    ```


## Task 02: Find the UUID of your assigned domain.

Ansible will need to know the UUID of your assigned domain in order to run the plabyooks. 
We need to open the FMC API explorer and log in with the credentials you will find in the FMC_access.txt file in directory.
As always replace XX with your assigned pod number

```commandline
cat /home/devnet/workshop/DEVWKS-2984/podXX/FMC_access.txt
```

After authenticating, navigate to System Information,

Select GET /api/fmc_platform/v1/info/domain

Click on Try it out, without making any changes, a blue Execute button should appear, click on it.
The response should look something like below:
```commandline

  "links": {
    "self": "https://35.247.118.180/api/fmc_platform/v1/info/domain?offset=0&limit=25"
  },
  "items": [
    {
      "uuid": "27f4034d-208f-c9b6-6724-000000000001",
      "name": "Global/devnet-d01",
      "type": "Domain"
    }
  ],
  "paging": {
    "offset": 0,
    "limit": 25,
    "count": 1,
    "pages": 1
  }
}
```
This indicates that the UUID for domain devnet-d01 is 27f4034d-208f-c9b6-6724-000000000001. In different pods, the UUID will be different.
Make sure you only use the UUID for your assigned domain!

## Task 03: Update vars.yml with the UUID.

Open `vars.yml` file and replace the domain_uuid with the UUID you determined in Task 02.


## Task 04: Register the FTDv that was pre-created into your FMC domain

Note: You might encounter an error like the one below when running the playbooks.
If you get an error that looks like the below error:
```commandline
ConnectionError: Failed to download API specification. Status code: 500. Response: b'command timeout triggered, timeout value is 30 secs.\\nSee the timeout setting options in the Network Debug and Troubleshooting Guide.'\n",
    "module_stdout": "",
    "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error",
    "rc": 1
}
```

Than you might need to set a higher timeout on Ansible side, there are multiple ways to do so as per the [Ansible documentation](https://docs.ansible.com/ansible/latest/network/user_guide/network_debug_troubleshooting.html#timeout-issues)
One easy way would be to create an environment variable:
```commandline
export ANSIBLE_PERSISTENT_COMMAND_TIMEOUT=90
```

Or you can run the script I created for you
```
./set_ansible_timeout.sh
```

Before we can start creating policy and pushing it to the firewall, we need to register the FTDv into FMC.
There is a playbook called playbook-register.yml that will do this. It will use the previously defined vars.yml file to learn the ip and registration key required to do so.

Run this command to execute the playbook:
```commandline
ansible-playbook -i hosts playbook-register.yml
```

If it completes successfully than you should see something like this at the end:

```commandline
TASK [Device Output] ***************************************************************************************************
ok: [35.247.118.180] => {
    "ftd": {
        "accessPolicy": {
            "id": "42010A0A-0005-0ed3-0000-004294978871",
            "type": "AccessPolicy"
        },
        "ftdMode": "ROUTED",
        "hostName": "10.10.0.11",
        "keepLocalEvents": false,
        "license_caps": [
            "BASE"
        ],
        "metadata": {
            "isMultiInstance": false,
            "isPartOfContainer": false,
            "task": {
                "id": "4294979014",
                "name": "DEVICE_REGISTRATION",
                "type": "TaskStatus"
            }
        },
        "name": "devnet-FTD",
        "performanceTier": "FTDv10",
        "regKey": "devnet-clus23",
        "type": "Device",
        "version": "6.0.1"
    }
}

PLAY RECAP *************************************************************************************************************
35.247.118.180             : ok=6    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Log into the FMC with the credentials from the pod documentation to monitor the progress of the device registration.

Note: You will see the playbook complete at the time the device registration completes. FMC will than still continue to deploy the access policy.

## Task 05: Get the list of registered devices from the FMC

Now that we have registered our first FTD into the FMC, let's run a playbook that will list all registerd devices.

In the file called 'playbook-devices.yml', fill in the UUID of your domain. 
Note that this is a different way of passing a variable into your playbook compared to the playbook we used to register the FTDv. 
Run the playbook as follows:
```commandline
ansible-playbook -i hosts playbook-devices.yml
```

If it runs to completion successfully, you should see something like this at the end:
```commandline
TASK [Debug devices] ***************************************************************************************************************************************************************
ok: [35.247.118.180] => {
    "devices": [
        {
            "id": "0f633984-ff90-11ed-ac2b-e45484ca6ef7",
            "links": {
                "self": "https://35.247.118.180/api/fmc_config/v1/domain/27f4034d-208f-c9b6-6724-000000000001/devices/devicerecords/0f633984-ff90-11ed-ac2b-e45484ca6ef7"
            },
            "name": "devnet-FTD",
            "type": "Device"
        }
    ]
}

PLAY RECAP *************************************************************************************************************************************************************************
35.247.118.180             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

## Task 06: Create some network objects

The purpose here is to show how to create some configuration on the FMC.
We will do this with the playbook called 'playbook-objects.yaml'.
Update the domain UUID, and if you want to, create some additional network objects.
Than push the objects into the FMC by running the playbook:
```commandline
ansible-playbook -i hosts playbook-objects.yml 
```

If the playbook runs to completion, you should see something like this at the end:
```commandline
PLAY [all] *************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************
ok: [35.247.118.180]

TASK [Create network object 10.10.10.0] ********************************************************************************************************************************************
ok: [35.247.118.180]

TASK [Create network object 10.10.20.0] ********************************************************************************************************************************************
ok: [35.247.118.180]

TASK [Create network object 10.10.30.0] ********************************************************************************************************************************************
ok: [35.247.118.180]

TASK [Create a Cisco network group] ************************************************************************************************************************************************
changed: [35.247.118.180]

TASK [Get Access Policy] ***********************************************************************************************************************************************************
ok: [35.247.118.180]

TASK [Create an access rule allowing trafic from Cisco DevNet] *********************************************************************************************************************
changed: [35.247.118.180]

PLAY RECAP *************************************************************************************************************************************************************************
35.247.118.180             : ok=7    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Log into the [FMC](https://35.247.118.180) with the credentials from the pod documentation to verify the objects have been created. (Objects -> Object Management)

## Task 07: Deploy the objects you created to your FTD.

In the final task of this lab we will push the created objects to the FTD.
Update the domain UUID in the file 'playbook-deploy.yml' and run it:
```commandline
ansible-playbook -i hosts playbook-deploy.yml 
```

It is normal to see it skipping the play called 'Complete playbook when nothing to deploy'

```commandline
PLAY [all] *************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************
ok: [35.247.118.180]

TASK [Get Deployable Devices] ******************************************************************************************************************************************************
ok: [35.247.118.180]

TASK [Debug output] ****************************************************************************************************************************************************************
ok: [35.247.118.180] => {
    "msg": "Available devices: devnet-FTD"
}

TASK [Complete playbook when nothing to deploy] ************************************************************************************************************************************
skipping: [35.247.118.180]

TASK [Fetch pending changes] *******************************************************************************************************************************************************
ok: [35.247.118.180]

TASK [Start deployment] ************************************************************************************************************************************************************
changed: [35.247.118.180]

TASK [Poll deployment status until the job is finished] ****************************************************************************************************************************
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (100 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (99 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (98 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (97 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (96 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (95 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (94 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (93 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (92 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (91 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (90 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (89 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (88 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (87 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (86 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (85 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (84 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (83 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (82 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (81 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (80 retries left).
FAILED - RETRYING: [35.247.118.180]: Poll deployment status until the job is finished (79 retries left).
ok: [35.247.118.180]

TASK [Stop the playbook if the deployment failed] **********************************************************************************************************************************
skipping: [35.247.118.180]

PLAY RECAP *************************************************************************************************************************************************************************
35.247.118.180             : ok=6    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   

```
