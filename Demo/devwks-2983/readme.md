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


## Task 02: Deploy an FMCv and an FTDv

In this task we will deploy a virtual FMC instance and a virtual FTD instance onto GCP.

1. Go to your directory

After having cloned the Secure Firewall examples repository, navigate to task02 directory in your assigned pod. 
Make sure you navigate to the directory for your assigned pod or you will cause conflicting changes with other users.
Ensure you replace podXX in the example below with your assigned pod.
```
cd secure-firewall/Demo/devwks-2983/podXX/task02/
```

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

line 17: admin_password = "provided_admin_password_goes_here"

lines 24, 30, 36, 42 and 49: Replace XX with 200 plus your provided pod number. 
So for example if your pod number is 04 than XX becomes 204, if your pod number is 11 than XX becomes 211.

lines 54-58: replace XX with your pod number

line 59: replace XX with 150 plus your pod number.
So for example if your pod number is 05 than XX becomes 155, if your pod number is 12, than XX becomes 162.

4. Update provders.tf file

Update the filename of credentials.json on lines 5 and 11

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

