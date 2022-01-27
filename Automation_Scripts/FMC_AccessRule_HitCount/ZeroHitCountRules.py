import argparse
import datetime
import requests
from requests.auth import HTTPBasicAuth
import urllib3
import csv

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

def create_parser():
    """
        Parsing commandline args
        :return
             dict with parsed value
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("--addr", required=True, help="Address of Cisco FMC")
    parser.add_argument("--username", required=True, help="Username of Cisco FMC")
    parser.add_argument("--password", required=True, help="Password of Cisco FMC")
    parser.add_argument("--device_name", required=True, help="FTD device name")
    parser.add_argument("--m", type=int, choices=range(1, 13),
                        help="The number of months elapsed since the rule was triggered last (optional)")

    return parser


def api_response(args, api_uri, method, extend, header):
    """
        Function that generate api response
        :param args:
            parsed args which includes address, username and password by Cisco FMC
        :param api_uri:
            path of call Cisco API
        :param method:
            HTTP method
        :param extend:
            enable or disable list of objects with additional attributes
        :param header:
            dictionary of request headers
        :return:
            api response
    """
    url = "https://" + args.addr + api_uri
    if extend:
        url = url + "?expanded=true"
    # response = requests.request(
    #     method,
    #     url,
    #     verify=False,
    #     headers=header,
    #     auth=HTTPBasicAuth(args.username, args.password)
    # )
    response = requests.request(
        method,
        url,
        verify=False,
        headers=header
    )
    return response


def fmc_gen_token(args):
    """
        Generate cisco FMC token
        :param args:
            parsed args which includes address, username and password by Cisco FMC
        :return:
            customized dictionary which contains access token, refresh token and domainUUID
    """
    api_uri = "/api/fmc_platform/v1/auth/generatetoken"
    url = "https://" + args.addr + api_uri
    response = requests.request(
        "POST",
        url,
        verify=False,
        auth=HTTPBasicAuth(args.username, args.password),
    )
    return {
        "X-auth-access-token": response.headers["X-auth-access-token"],
        "X-auth-refresh-token": response.headers["X-auth-refresh-token"],
        "DOMAIN_UUID": response.headers["DOMAIN_UUID"]
    }


def request_headers(fmc_token):
    """
        Function to help to generate request headers
        :param fmc_token:
            dictionary of token response which includes X-auth-access-token required by Cisco FMC to access REST API
        :return:
            dictionary of headers
    """
    return {
        "X-auth-access-token": fmc_token["X-auth-access-token"],
        "Content-Type": "application/json"
    }


def get_policy_assignment(args, fmc_token, headers):
    """
        Get policy id for FTD device
        :param args:
            parsed args which includes address, username and password by Cisco FMC
        :param fmc_token:
            dictionary of token response which includes X-auth-access-token required by Cisco FMC to access REST API
        :param headers:
            dictionary of request headers
        :return:
            customize dictionary which contains policy id and device id
    """
    device_id = None
    policy_id = None
    api_uri = f'/api/fmc_config/v1/domain/{fmc_token["DOMAIN_UUID"]}/assignment/policyassignments'
    response = api_response(args, api_uri, "GET", True, headers)

    if "items" in response.json():
        for i in response.json()["items"]:
            for k in i["targets"]:
                if k["name"] == args.device_name:
                    device_id = k["id"]
                    policy_id = i["policy"]["id"]
                    print("Policy mapped to the device: " + i["policy"]["name"])
                    break

    if device_id is None:
        raise ValueError(f'Device with name {args.device_name} not found')
    else:
        return {"Device_id": device_id, "Policy_id": policy_id}


def refresh_hit_count_rule(args, fmc_token, policy, headers):
    """
        Refresh the hit count of the rule
        :param args:
            parsed args which includes address, username and password by Cisco FMC
        :param fmc_token:
            dictionary of token response which includes X-auth-access-token required by Cisco FMC to access REST API
        :param policy:
            dictionary of policy assignment which includes policy id and device id
        :param headers:
            dictionary of request headers
        :return:
            None
    """
    api_uri = f'/api/fmc_config/v1/domain/{fmc_token["DOMAIN_UUID"]}/policy/accesspolicies/{policy["Policy_id"]}/operational/hitcounts'
    response = api_response(args,
                            api_uri + f'?filter=deviceId%3A%20{policy["Device_id"]}',
                            "PUT", False, headers)
    if response.status_code != 202:
        raise KeyError('Unable refresh hit count rule')


def get_hit_count_rule(args, fmc_token, policy, headers):
    """
        Get the hit count of the rule
        :param args:
            parsed args which includes address, username and password by Cisco FMC
        :param fmc_token:
            dictionary of token response which includes X-auth-access-token required by Cisco FMC to access REST API
        :param policy:
            dictionary of policy assignment which includes policy id and device id
        :param headers:
            dictionary of request headers
        :return:
            dictionary which contains json response with all rules and their hit count
    """
    api_uri = f'/api/fmc_config/v1/domain/{fmc_token["DOMAIN_UUID"]}/policy/accesspolicies/{policy["Policy_id"]}/operational/hitcounts'
    response = api_response(args,
                            api_uri + f'?filter=deviceId%3A%20{policy["Device_id"]}' + '&expanded=true',
                            "GET", False, headers)
    if "items" in response.json():
        return response.json()["items"]
    else:
        raise ValueError('Not found any rules')


def zero_hit_count_rules(hit_count_rules):
    """
        Get list of zero hit count rules
        :param hit_count_rules:
            dictionary which contain json response with all hit count rules
        :return:
            list with all zero hit count rules (contain rule name, id, type and access policy name)
    """
    rule = []
    for i in hit_count_rules:
        if i["hitCount"] == 0:
            rule.append(i["rule"])
    #rule.append({"Policy name": hit_count_rules[0]["metadata"]["policy"]["name"]})
    return rule


def last_hit_timestamp(hit_count_rules, month):
    """
        Get list of last hit timestamp to rule
        :param hit_count_rules:
            dictionary which contain json response with all hit count rules
        :param month:
            number of month elapsed since the rule was triggered last
        :return:
            list with rules that older than value in param month (contain rule name, id, type and access policy name)
    """
    rule = []
    for i in hit_count_rules:
        last_refresh = datetime.datetime.strptime(i["lastFetchTimeStamp"], '%Y-%m-%dT%H:%M:%SZ')
        limit = last_refresh - datetime.timedelta(month * 365 / 12)
        if i["lastHitTimeStamp"] != " ":
            last_hit = datetime.datetime.strptime(i["lastHitTimeStamp"], '%Y-%m-%dT%H:%M:%SZ')
            if last_hit < limit:
                rule.append(i["rule"])
    return rule


def main():
    f = open('hitcount.csv', 'w')
    writer = csv.writer(f)
    parser = create_parser()
    args = parser.parse_args()
    fmc_token = fmc_gen_token(args)
    headers = request_headers(fmc_token)
    policy_data = get_policy_assignment(args, fmc_token, headers)
    refresh_hit_count_rule(args, fmc_token, policy_data, headers)
    hit_count_rules = get_hit_count_rule(args, fmc_token, policy_data, headers)
    if args.m is None:
        zero_rules = zero_hit_count_rules(hit_count_rules)
        if not zero_rules:
            print('Not found any zero hit count rules')
            writer.writerow(['Not found any zero hit count rules'])
        else:
            print("Following rules have a zero hit count:")
            writer.writerow(['Following rules have a zero hit count'])
            for z in zero_rules:
                print(z["name"])
                writer.writerow([z["name"]])
    else:
        rules = last_hit_timestamp(hit_count_rules, args.m)
        if not rules:
            print(f'Not found hit count rules older than {args.m} month(s)')
            writer.writerow([f'Not found hit count rules older than {args.m} month(s)'])
        else:
            print("Following rules have hit count older than {args.m} month(s)")
            writer.writerow(["Following rules have hit count older than {args.m} month(s)"])
            for r in rules:
                print(r["rule"]["name"])
                writer.writerow([r["rule"]["name"]])
    f.close()


if __name__ == '__main__':
    main()