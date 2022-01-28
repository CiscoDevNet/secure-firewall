import requests
import argparse
from requests.auth import HTTPBasicAuth
import urllib3
import csv

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def createParser ():
    parser = argparse.ArgumentParser()
    parser.add_argument("--addr", required=True, help="Address of Cisco FMC")
    parser.add_argument("--username", required=True, help="Username of Cisco FMC")
    parser.add_argument("--password", required=True, help="Password of Cisco FMC")
    parser.add_argument("--policy_name", required=True, help="Access policy name")
    parser.add_argument("--ip", nargs="+", required=True,
                        help="Ip or network object id (list). "
                             "Example: -- ip 0.0.0.0 dde11d62-288b-4b4c-92e0-1dad0496f14b")
    parser.add_argument("--delete", nargs='?', const=True, type=bool, help="Argument to be used if the rules should be deleted")

    return parser


def fmc_gen_token():
    api_uri = "/api/fmc_platform/v1/auth/generatetoken"
    url = "https://" + args.addr + api_uri
    response = requests.post(
        url,
        verify=False,
        auth=HTTPBasicAuth(args.username, args.password),
    )
    return {
        "X-auth-access-token": response.headers["X-auth-access-token"],
        "X-auth-refresh-token": response.headers["X-auth-refresh-token"],
        "DOMAIN_UUID": response.headers["DOMAIN_UUID"]
    }


def get_policy_assignment(fmc_token):
    api_uri: str = f'/api/fmc_config/v1/domain/{fmc_token["DOMAIN_UUID"]}/policy/accesspolicies'
    url = "https://" + args.addr + api_uri
    headers = {
        "X-auth-access-token": fmc_token["X-auth-access-token"],
        'Content-Type': 'application/json'
    }
    response = requests.get(
        url + f"?name={args.policy_name}",
        headers=headers,
        verify=False
    )
    return {"policy_id": response.json()["items"][0]["id"], "headers": headers}


def get_access_rule(fmc_token, policy_id):
    api_uri: str = f'/api/fmc_config/v1/domain/{fmc_token["DOMAIN_UUID"]}/policy/accesspolicies/{policy_id["policy_id"]}/accessrules'
    url = "https://" + args.addr + api_uri
    response = requests.get(
        url + "?expanded=true",
        headers=policy_id["headers"],
        verify=False
    )
    return response.json()["items"]


rule_ids = []
rule_names = []

def find_rule(networks, access_rule):
    for i in access_rule:
        if networks in i:
            key_object("literals", "value", networks, i)
            key_object("objects", "id", networks, i)


def key_object(object_type, field, networks, i):
    if object_type in i[networks]:
        for k in i[networks][object_type]:
            if k[field] in args.ip:
                rule_ids.append(i["id"])
                rule_names.append(i["name"])


def delete_access_rule(fmc_token, policy_id, rule_ids):
    api_uri: str = f'/api/fmc_config/v1/domain/{fmc_token["DOMAIN_UUID"]}/policy/accesspolicies/{policy_id["policy_id"]}/accessrules'
    url = "https://" + args.addr + api_uri
    response = requests.delete(
        url + f'?bulk=true&filter=ids%3A{"%2C".join(rule_ids)}',
        headers=policy_id["headers"],
        verify=False
    )
    return response.status_code

f = open('/Users/sameersingh/Documents/vitalii/decomission/decommision.csv', 'w')
writer = csv.writer(f)
parser = createParser()
args = parser.parse_args()
fmc_token = fmc_gen_token()
policy_id = get_policy_assignment(fmc_token)
access_rule = get_access_rule(fmc_token, policy_id)
find_rule("sourceNetworks", access_rule)
find_rule("destinationNetworks", access_rule)
rule_ids = list(set(rule_ids))
print("Following rules have been identified to contain the provided IP Address or Object ID")
writer.writerow(["Following rules have been identified to contain the provided IP Address"])
print(rule_names)
for r in rule_names:
    writer.writerow([r])
if args.delete == True:
    status_code = delete_access_rule(fmc_token, policy_id, rule_ids)
    print(status_code)
f.close()