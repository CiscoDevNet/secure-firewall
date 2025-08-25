import Devmiko
import getpass

host = "<Host_IP>"
username = "admin"
password = "<Password>"

client = Devmiko.FTDClient(debug=False, filename=None, level='DEBUG')
client.connect(host, username=username, password=password)

client.send_command(command='configure firewall transparent')
client.send_command(command='y')
client.send_command(command='configure firewall routed')
client.send_command(command='y')
client.send_command(command='configure manager add <Host_ip> cisco123')
print(client.output)
client.disconnect()