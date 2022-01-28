This script allows you to identify and remove rules containing specific IPs from the access policy.

#### REQUIREMENTS

The minimum requirement by script is the installed _python3_ and library _request_ for python.   
Find out python version use command:
 $ `python3 --version`  
Install library request:
 $ `python -m pip install requests`

More information about _request_ library - [https://docs.python-requests.org/en/master/]

#### USING THE SCRIPT

1. Download script or copy.
2. To run script use command:
  $ python3 ./main.py --username <'USERNAME'> --password <'PASSWORD'> --addr <'ADDRESS'> --policy_name <'POLICY NAME'>  --ip <'IP'> [--delete]
To view a description of the parameters, use: -h or --help

#### PARAMETERS

 - <'USERNAME'>:    Username of Cisco FMC. Example: admin
 - <'PASSWORD'>:    Password of Cisco FMC. Example: my pass
 - <'ADDRESS'>:     Address of Cisco FMC. Example: 81.32.62.4
 - <'POLICY NAME'>: Name of access policy. Example: AccessPolicy1
 - <'IP'>:          IP or network object id. Example: 0.0.0.0 dde11d62-288b-4b4c-92e0-1dad0496f14b
 - [--delete]:      Optional argument to be used if the identified rules should be deleted

**Note:** This script lists all rules containing the mentioned IP address or object UUID, including rules containing additional network elements.

#### ADDITIONAL

Two ways of making a REST call are provided. One with "SSL verification turned off" and the other with "SSL verification turned on".  
REST call with SSL verification turned on: Download SSL certificates from your FMC first and provide its path for verification. For that use `verify='/path/to/ssl_certificate'`
instead of `verify='False'`. 
`response = requests.post(auth_url, headers=headers, auth=requests.auth.HTTPBasicAuth(username,password), verify='/path/to/ssl_certificate')`
