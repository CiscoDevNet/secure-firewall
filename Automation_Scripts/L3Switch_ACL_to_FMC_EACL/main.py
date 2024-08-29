import requests
import json
import ipaddress
import argparse

requests.packages.urllib3.disable_warnings()

parser = argparse.ArgumentParser()

parser.add_argument("--delete", action="store_true", help="Delete all resources created by the script") 
parser.add_argument('--fmc', nargs='?', help="FMC IP Address or FQDN", required=True)
parser.add_argument('--username', nargs='?', help="FMC Username", required=True)
parser.add_argument('--password', nargs='?', help="FMC Password", required=True)
parser.add_argument('--file', nargs='?', help="File containing L3 Switch Extended Access Lists", required=True)
args = parser.parse_args() 

delete = args.delete
host = args.fmc
username = args.username
password = args.password
file_name = args.file

response = requests.post("https://"+host+"/api/fmc_platform/v1/auth/generatetoken", 
    headers={"Content-Type": "application/json"},
    auth=(username, password),
    verify=False
)

access_token = response.headers["X-Auth-Access-Token"]
domain_uuid = response.headers["DOMAIN_UUID"]

ports={}
ips={}

def delete_object(name, id):
    requests.delete("https://"+host+"/api/fmc_config/v1/domain/"+domain_uuid+"/object/"+name+"/"+id,
        headers={
            "X-Auth-Access-Token": access_token
        },
        verify=False
    )

def create_objects_bulk(name, objs):
    res = requests.post("https://"+host+"/api/fmc_config/v1/domain/"+domain_uuid+"/object/"+name+"?bulk=true", 
        data=json.dumps(objs, sort_keys=True, indent=4),
        headers={
            "Content-Type": "application/json",
            "X-Auth-Access-Token": access_token
        },
        verify=False
    )

    return res

def is_ip(address):
    try:
        host_bytes = address.split('.')
        valid = [int(b) for b in host_bytes]
        valid = [b for b in valid if b >= 0 and b<=255]
        return len(host_bytes) == 4 and len(valid) == 4
    except:
        return False

def wildcard_to_netmask(wildcard):
    return str(ipaddress.ip_network(wildcard, strict=False).netmask)

with open(file_name, 'r') as file:
    eacl_name = file.readline().split(" ")[3].rstrip()

    while True:
        line = file.readline()

        if not line:
            break

        protocol = line.split(" ")[3].upper()
        
        for i, x in enumerate(line.split(" ")):
            if x == "eq":
                port = line.split(" ")[i+1].rstrip()
                if port.isdigit():
                    if port in ports:
                        ports[port] = {'count': ports[port]['count']+1, 'id': ports[port]['id'], 'protocol': ports[port]['protocol']}
                    else:
                        ports[port] = {'count': 1, 'id': None, 'protocol': protocol}
            
            if is_ip(x.rstrip()) and not is_ip(line.split(" ")[i-1].rstrip()):
                if x.rstrip() in ips:
                    ips[x.rstrip()] = {'count': ips[x.rstrip()]['count']+1, 'subnet': ips[x.rstrip()]['subnet'], 'id': ips[x.rstrip()]['id'], 'invalid': False}
                else:
                    ips[x.rstrip()] = {'count': 1, 'subnet': None, 'id': None, 'invalid': False}
            elif is_ip(x.rstrip()) and is_ip(line.split(" ")[i-1].rstrip()):
                if x.rstrip() in ips:
                    k = line.split(" ")[i-1].rstrip()+"/"+wildcard_to_netmask(line.split(" ")[i-1].rstrip()+"/"+x.rstrip())
                    ips[k] = {'count': ips[k]['count']+1, 'subnet': ips[k]['subnet'], 'id': ips[k]['id'], 'invalid': ips[k]['invalid']}
                else:
                    try:
                        ips[line.split(" ")[i-1].rstrip()+"/"+wildcard_to_netmask(line.split(" ")[i-1].rstrip()+"/"+x.rstrip())] = {'count': 1, 'subnet': str(ipaddress.ip_network(line.split(" ")[i-1].rstrip()+"/"+x.rstrip(), strict=False).netmask), 'id': None, 'invalid': False}
                    except Exception:
                        ips[line.split(" ")[i-1].rstrip()+"/"+x.rstrip()] = {'count': 1, 'subnet': None, 'id': None, 'invalid': True}


host_objects_bulk = []
nw_objects_bulk = []
port_objects_bulk = []

for key in ips.keys():
    if ips[key]["subnet"] == None and not ips[key]["invalid"]:
        host_object = {
            'name': key,
            'type': 'Host',
            'value': key
        }

        host_objects_bulk.append(host_object)
    elif not ips[key]["invalid"]:
        nw_object = {
            'name': key.split("/")[0]+"-"+ips[key]["subnet"],
            'type': 'Network',
            'value': key
        }

        nw_objects_bulk.append(nw_object)

for key in ports.keys():
    port_object = {
        'name': key+"-"+ports[key]["protocol"],
        'protocol': ports[key]["protocol"],
        'port': key,
        'type': "ProtocolPortObject"
    }

    port_objects_bulk.append(port_object)

response = create_objects_bulk("hosts",host_objects_bulk)

if not response.status_code == 400:
    for item in response.json()["items"]:
        ips[item["value"]] = {'count': ips[item["value"]]["count"], 'subnet': ips[item["value"]]["subnet"], 'id': item["id"]}

        with open('host_objects.txt', 'a') as file:
            file.write(item["id"])
            file.close()

response = create_objects_bulk("networks", nw_objects_bulk)

if not response.status_code == 400:
    for item in response.json()["items"]:
        ips[item["value"]] = {'count': ips[item["value"]]["count"], 'subnet': ips[item["value"]]["subnet"], 'id': item["id"]}

        with open('nw_objects.txt', 'a') as file:
            file.write(item["id"])
            file.close()

response = create_objects_bulk("protocolportobjects", port_objects_bulk)

if not response.status_code == 400:
    for item in response.json()["items"]:
        ports[item["port"]] = {'count': ports[item["port"]]["count"], 'protocol': ports[item["port"]]["protocol"], 'id': item["id"]}

        with open('port_objects.txt', 'a') as file:
            file.write(item["id"])
            file.close()

if not delete:
    with open(file_name, 'r') as file:
        eacl_name = file.readline().split(" ")[3].rstrip()
        print("Skipping:")

        entries = []

        while True:
            line = file.readline().rstrip()

            if not line:
                break

            if "range" in line:
                # print("["+line.split(" ")[1]+"] Skipping rule due to range of ports: "+line.split("range")[1].lstrip().rstrip().split(" ")[0]+" "+line.split("range")[1].lstrip().rstrip().split(" ")[1])
                print(line)
                continue
            
            if "gt" in line or "lt" in line:
                print(line)
                continue
            
            if "eq" in line:
                try:
                    if not line.split("eq")[1].rstrip()[1].isdigit():
                        # print("["+line.split(" ")[1]+"] Skipping rule due to undefined port: "+line.split("eq")[1].rstrip().split(" ")[1])
                        print(line)
                        continue
                    elif not line.split("eq")[2].rstrip()[1].isdigit():
                        # print("["+line.split(" ")[1]+"] Skipping rule due to undefined port: "+line.split("eq")[2].rstrip().split(" ")[1])
                        print(line)
                        continue
                except IndexError:
                    pass

            action = line.split(" ")[2].upper()
            source_network = None
            source_port = None
            dest_network = None
            dest_port = None

            dest_index = 1
            src_dest = str.split(line)[3:]


            if not src_dest[0] == "any":
                if not src_dest[0] == "host":
                    if src_dest[0]+"/"+src_dest[1] in ips.keys():
                        print(line)
                        continue
                    
                    source_network = {
                        'id': ips[src_dest[0]+"/"+wildcard_to_netmask(src_dest[0]+"/"+src_dest[1])]["id"]
                    }
                else:
                    source_network = {
                        'id': ips[src_dest[1]]["id"]
                    }
                dest_index += 1

                if 2 < len(src_dest):
                    if src_dest[2] == "eq":
                        source_port = {
                            'id': ports[src_dest[3]]["id"]
                        }

                        dest_index += 2
            else:
                if 1 < len(src_dest):
                    if src_dest[1] == "eq":
                        source_port = {
                            'id': ports[src_dest[2]]["id"]
                        }

                        dest_index += 2

            if not src_dest[dest_index] == "any":
                if not src_dest[dest_index] == "host":
                    if src_dest[dest_index]+"/"+src_dest[dest_index+1] in ips.keys():
                        print(line)
                        continue
                    
                    dest_network = {
                        'id': ips[src_dest[dest_index]+"/"+wildcard_to_netmask(src_dest[dest_index]+"/"+src_dest[dest_index+1])]["id"]
                    }
                else:
                    dest_network = {
                        'id': ips[src_dest[dest_index+1]]["id"]
                    }

                if dest_index+2 < len(src_dest):
                    if src_dest[dest_index+2] == "eq":
                        dest_port = {
                            'id': ports[src_dest[dest_index+3]]["id"]
                        }
            else:
                if dest_index+1 < len(src_dest):
                    if src_dest[dest_index+1] == "eq":
                        dest_port = {
                            'id': ports[src_dest[dest_index+2]]["id"]
                        }

            entry = {}

            entry['action'] = action

            entry['logLevel'] = "ERROR"

            entry['logging'] = "PER_ACCESS_LIST_ENTRY"

            entry['logInterval'] = 545
            
            if not source_network == None:
                entry['sourceNetworks'] = {
                    'objects': [source_network]
                }

            if not source_port == None:
                entry['sourcePorts'] = {
                    'objects': [source_port]
                }
            
            if not dest_network == None:
                entry['destinationNetworks'] = {
                    'objects': [dest_network]
                }

            if not dest_port == None:
                entry['destinationPorts'] = {
                    'objects': [dest_port]
                }

            entries.append(entry)

        response = requests.post("https://"+host+"/api/fmc_config/v1/domain/"+domain_uuid+"/object/extendedaccesslists", 
            data=json.dumps({'name': eacl_name, 'entries': entries}, sort_keys=True, indent=4),
            headers={
                "Content-Type": "application/json",
                "X-Auth-Access-Token": access_token
            },
            verify=False
        )

        with open('extended_acl.txt', 'a') as file:
            file.write(response.json()["id"])
            file.close()

# Delete
if delete:
    with open('extended_acl.txt', 'r') as file:
        id = file.readline().rstrip()
        delete_object("extendedaccesslists", id)

    with open('host_objects.txt', 'r') as file:
        ids = file.readline().rstrip()

        for id in [ids[i:i+36] for i in range(0, len(ids), 36)]:
            delete_object("hosts", id)

    with open('nw_objects.txt', 'r') as file:
        ids = file.readline().rstrip()

        for id in [ids[i:i+36] for i in range(0, len(ids), 36)]:
            delete_object("networks", id)

    with open('port_objects.txt', 'r') as file:
        ids = file.readline().rstrip()

        for id in [ids[i:i+36] for i in range(0, len(ids), 36)]:
            delete_object("protocolportobjects", id)

    open('host_objects.txt', 'w').close()
    open('nw_objects.txt', 'w').close()
    open('port_objects.txt', 'w').close()
    open('extended_acl.txt', 'w').close()

    print("All resources deleted successfully")