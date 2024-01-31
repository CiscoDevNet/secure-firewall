#DEVWKS-2983 Deploy FTDv and FMCv on GCP with Terraform

## Task 01

1. Check if Terraform is installed
```
terraform version
```
2. Access the FMC

Check if you can access the FMC. This is a pre-created FMC that we will use to register the FTD instance into that you will create in task 02. The reason is that it will take too long for the FMC you deploy to become fully initialized. You can find the ip address, username and password in the directory for your pod number.
Replace podXX in the example below with your assigned pod.
```
cd /home/devnet/workshop/DEVWKS-2983/podXX/
cat FMC_access.txt
```

That should show the address, username and password to use to access your own domain inside the FMC.
Note that we created a domain for each pod, so your username will look like devnet-domainXX\devnet-userXX.

## Task 02: Deploy an FMCv and an FTDv

In this task we will deploy a virtual FMC instance and a virtual FTD instance onto GCP.

1. Go to your directory

Navigate to task02 directory in your assigned pod. 
Make sure you navigate to the directory for your assigned pod or you will cause conflicting changes with other users.
Replace podXX in the example below with your assigned pod.
```
cd /home/devnet/workshop/DEVWKS-2983/podXX/task02/
```

2. Initialize Terraform

Run the below command to make Terraform download the required providers
```
terraform init
```
This will set up Terraform ready for use. If you get an error like: 'Terraform initialized in an empty directory!' than you did not go into the correct directory. Please follow the steps listed above to go to the right directory.

You should see something like this when doing terraform init:
```
JWITTOCK:task02 jwittock$ terraform init

Initializing the backend...
Initializing modules...
- networking in modules/networking
Downloading registry.terraform.io/terraform-google-modules/network/google 3.5.0 for networking.vpc-module...
- networking.vpc-module in .terraform/modules/networking.vpc-module
- networking.vpc-module.firewall_rules in .terraform/modules/networking.vpc-module/modules/firewall-rules
- networking.vpc-module.routes in .terraform/modules/networking.vpc-module/modules/routes
- networking.vpc-module.subnets in .terraform/modules/networking.vpc-module/modules/subnets
- networking.vpc-module.vpc in .terraform/modules/networking.vpc-module/modules/vpc
- vm in modules/vm

Initializing provider plugins...
- Finding hashicorp/google-beta versions matching "~> 3.45, ~> 3.79, < 4.0.0"...
- Finding hashicorp/template versions matching "~> 2.2.0"...
- Finding hashicorp/google versions matching ">= 2.12.0, ~> 3.45, ~> 3.79, < 4.0.0"...
- Installing hashicorp/google-beta v3.90.1...
- Installed hashicorp/google-beta v3.90.1 (signed by HashiCorp)
- Installing hashicorp/template v2.2.0...
- Installed hashicorp/template v2.2.0 (signed by HashiCorp)
- Installing hashicorp/google v3.90.1...
- Installed hashicorp/google v3.90.1 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
JWITTOCK:task02 jwittock$ 
```

3. Review variables in terraform.tfvars file

Most of the variables should be filled in for you already.

```
cat terraform.tfvars
```
This command should list out all the variables, have a look and if you have any questions regarding what these do, feel free to ask.


4. Verify that Terraform knows what to do

To check what Terraform will actually do when we go and deploy everything, run the following command:
```
terraform plan
```
It should show a list of new resources to create.

5. Deploy the two instances

Now we will actually go and deploy the virtual FMC and the virtual FTD. Use the below command to start the process.
```
terraform apply
```
Enter yes when asked.

## Task03: Create an access-policy and register the pre-created FTDv into the provided FMC instance.

This Terraform script will create an access policy on the FMC that was pre-created (so you would not need to wait on your FMC to finish initializing). It will create an object and it will register the pre-created FTDv into the FMC.

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
Note that since we are in a different directory from task02, terraform needs to be initialized again, and a new, separate statefile will be created and maintained.
The output should look something like:
```
JWITTOCK:task03 jwittock$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of ciscodevnet/fmc...
- Installing ciscodevnet/fmc v1.4.6...
- Installed ciscodevnet/fmc v1.4.6 (self-signed, key ID 817ED05B1A758063)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
JWITTOCK:task03 jwittock$
```

3. Review the terraform.tfvars file

```
cat terraform.tfvars
```

4. Verify the changes Terraform intends to make.

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
Enter yes when asked. This will take some time.

Log into the FMC to see the progress of the policy being created and the FTD being registered. This step takes on average about 5 minutes.


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
terraform destroy --auto-approve
cd ../task03
terraform destroy --auto-approve
cd ../task02
terraform destroy --auto-approve
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
