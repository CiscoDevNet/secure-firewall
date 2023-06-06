#DEVWKS-2983 Deploy FTDv and FMCv on GCP with Terraform

## Task 01

1. Check if Terraform is installed
```
terraform version
```
2. Clone the secure-firewall repository
```
git clone https://github.com/CiscoDevNet/secure-firewall.git
```
3. Access the FMC

Check if you can access the [FMC](https://35.247.118.180) with the provided username and password.

4. Create an SSH key

In the example below, replace XX with your assigned pod number.
```
ssh-keygen -b 2048 -t rsa -f devnet-userXX-key -C devnet-userXX
```
Do not use a password to press enter without providing any input when asked.

## Task 02: Deploy an FMCv and an FTDv

In this task we will deploy a virtual FMC instance and a virtual FTD instance onto GCP.

1. Go to your directory

After having cloned the Secure Firewall examples repository, navigate to task02 directory in your assigned pod. 
Make sure you navigate to the directory for your assigned pod or you will cause conflicting changes with other users.
Ensure you replace podXX in the example below with your assigned pod.
```
cd secure-firewall/Demo/devwks-2983/podXX/task02/
```

Next, in the Webex chat for the session you will be given the ip and credentials of the jumphost. Make sure to copy the pod information for your assigned pod!

2. Initialize Terraform

Run the below command to make Terraform download the required providers
```
terraform init
```

3. Fill in all required variables in terraform.tfvars file

For all the mentioned lines, fill in the variable as indicated. Use usernames, passwords and ip addresses from the provided table with credentials. 
Ensure to replace podXX with your assigned pod number.
The folder should also contain a file called terraform.tfvars.example where most of the fields will be filled in, however they will NOT be specific for your pod!!

line 2: devnet_pod = "podXX"

line 14: ftd_hostname = "devnet-ftd-"

For line 16 you will need to add the public key you created, use the following command to show the public key, replacing userXX with your user number.
```
cat devnet-userXX-key.pub
```

line 16: admin_ssh_pub_key = "contents_of_devnet-userXX-key.pub_goes_here"

line 17: admin_password = "provided_FMC_admin_password_goes_here"

lines 24, 30, 36, 42 and 49: Replace XX with 200 plus your provided pod number. 
So for example if your pod number is 04 than XX becomes 204, if your pod number is 11 than XX becomes 211.

lines 54-58: replace XX with your pod number

line 59: replace XX with 150 plus your pod number.
So for example if your pod number is 05 than XX becomes 155, if your pod number is 12, than XX becomes 162.

4. Verify provders.tf file

Validate that the filename of credentials.json on lines 5 and 11 matches with what you downloaded into this folder in an earlier step.

5. Verify that Terraform knows what to do

To check what Terraform will actually do when we go and deploy everything, run the following command:
```
terraform plan
```
It should show a list of new resources to create.

6. Deploy the two instances

Now we will actually go and deploy the virtual FMC and the virtual FTD. Use the below command to start the process.
```
terraform apply
```
Enter yes when asked.

## Task03: Create an access-policy and register the pre-created FTDv into the provided FMC instance.

It will take upwards of 10 minutes for an FTD to fully initialize and over 30 minutes for a fresh FMC to initialize. 
Therefore an FMC instance has been created and access to this instance was tested in Task01. In addition an FTDv instance was created for every pod.
Every pod has it's own domain in the FMC and we will now create an access-policy in the pod domain and register the FTDv in the FMC instance.

1. Change directory to task03 directory:
```
cd ../task03
```

2. Initialize Terraform

Download the required providers by running the following command:
```
terraform init
```
Note that since we are in a different directory from task02, terraform needs to be initialized again, and a new, separate statefile will be created and maintained

3. Update the terraform.tfvars file:

Replace XX with assigned pod number and fill in remaining values with inputs from table with credentials.

4. Update the outputs.tf file:

Ensure it will show the id of your FTDv, so change the FTDv number to your assigned FTDv.

So for example if your assigned FTDv name is devnet-clus23-ftd-1, than the file should look like this:

```
output "fmc_device_id" {
  value = fmc_devices.devnet-clus23-ftd-1.id
  description = "ID of the registered FTD in FMC."
}
```

5. Verify the changes Terraform intends to make.

Before actually deploying the changes, it is always good to first check the proposed changes. Run the below command to evaluate what Terraform intends to do:
```
terraform plan
```
Make sure all values reflect the right pod numbers, host names, passwords, etc ...

5. Deploy the access-policy and register the FTDv into the FMCv

Run the following command to have Terraform create the access-policy and register the FTDv.
```
terraform apply
```
Enter yes when asked.

Log into the [FMC](https://35.247.118.180) to see the progress of the policy being created and the FTD being registered. This step takes on average about 5 minutes.

## Task04: Create a NAT policy and push it to the FTD.

1. First change into the appropriate directory

We want to show how to apply policy to an existing FTD so we will go to a different directory:
```
cd ../task04
```
This will cause terraform to again start from a blank canvas. So we will need to initialize terraform again.

2. Create the NAT policy, update the values from terraform.tfvars

Fill in the required values in terraform.tfvars based on the provided table with credentials and hostnames.

3. Initialize Terraform and check what changes are proposed

```
terraform init
terraform plan
```

4. Push the NAT policy to the FTD

Now that terraform knows what to do, let's execute Terraform again and deploy to the FTDv
```
terraform apply
```
Ensure to enter yes when asked.

Log into the [FMC](https://35.247.118.180) and verify the NAT policy is created and applied.

## Task05: Check access to the FMC you created

By now the FMC should be up and running, so connect to the ip address that the output of task02 showed and try to go to the UI and log in with username admin and the password you provided in the terraform.tfvars file.

## Task06: Remove the FTDv and FMCv you created

Navigate back to directory called task02 and so that we can clean up everything you created. 

- Make sure you are in the right directory before issuing this command to ensure you only remove what you created in task 02! 
- Review the output before entering yes to continue with the cleanup. It should indicate that it will remove 20 resources.

```
terraform destroy
```

If everything goes according to plan, you should see something like this when asked to confirm the destroy action:

```
Plan: 0 to add, 0 to change, 20 to destroy.

Changes to Outputs:
  - FMC_Public_IP = [
      - [
          - "a.b.c.d",
        ],
    ] -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
  ```
