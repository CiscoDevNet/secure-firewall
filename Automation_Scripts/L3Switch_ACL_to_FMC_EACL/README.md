# Migrate L3 Switch Access List to FMC Extended Access List

## Unsupported Rules:
Rules with-
* Range of ports
* `gt` or `lt` ports
* Invalid wildcard mask for example 0.255.0.0, 0.255.255.0, etc.
* Named ports(http, ssh, etc). You can bypass this limitation by converting them to integers(80, 22, etc)

## Install Requirements:
```
pip install -r requirements.txt
```

## Usage Instructions:
```
usage: main.py [-h] [--delete] --fmc [FMC] --username [USERNAME] --password [PASSWORD] --file [FILE]

options:
  -h, --help            show this help message and exit
  --delete              Delete all resources created by the script
  --fmc [FMC]           FMC IP Address or FQDN
  --username [USERNAME]
                        FMC Username
  --password [PASSWORD]
                        FMC Password
  --file [FILE]         File containing L3 Switch Extended Access Lists
```

## Usage Example:

### To migrate-
```
python3 main.py --fmc X.X.X.X --username username --password password --file Extended_ACLs.txt
```

### To revert the migration-
```
python3 main.py --fmc X.X.X.X --username username --password password --file Extended_ACLs.txt --delete
```