### This python script covers two functions
* provides a list of rules with Zero Hit counts in the access policy assigned to the device 
* provides a list of rules with last hit older than mentioned period in the access policy assigned to the device
The list is printed on terminal and written to a csv file.

#### REQUIREMENTS

The minimum requirement by script is the installed _python3_ and library _request_ for python.   
Find out python version use command:
 $ `python3 --version`  
Install library request:
 $ `python -m pip3 install requests`

More information about _request_ library - [https://docs.python-requests.org/en/master/]

#### USING THE SCRIPT

1. Download script or copy.
2. To run script use command:
  $ python3 ./ZeroHitCount.py --username <'USERNAME'> --password <'PASSWORD'> --addr <'ADDRESS'> --device_name <'DEVICE NAME'> [--m <'MONTHS (1-12)'>]
To view a description of the parameters, use: -h or --help

#### PARAMETERS

 - <'USERNAME'>:      Username of Cisco FMC. Example: admin
 - <'PASSWORD'>:      Password of Cisco FMC. Example: my pass
 - <'ADDRESS'>:       Address of Cisco FMC. Example: 81.32.62.4
 - <'DEVICE NAME'>:   Name of FTD device. Example: FTD-service
 - <'MONTHS (1-12)'>: The number of months elapsed since the rule was triggered last

#### ADDITIONAL

Two ways of making a REST call are provided. One with "SSL verification turned off" and the other with "SSL verification turned on".  
REST call with SSL verification turned on: Download SSL certificates from your FMC first and provide its path for verification. For that use `verify='/path/to/ssl_certificate'`
instead of `verify='False'`. 
`response = requests.post(auth_url, headers=headers, auth=requests.auth.HTTPBasicAuth(username,password), verify='/path/to/ssl_certificate')`