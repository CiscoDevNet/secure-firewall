import Devmiko
import getpass

host = "3.142.207.89"
username = "admin"
password = "Cisco@123"

client = Devmiko.FTDClient(debug=False, filename=None, level='DEBUG')
client.connect(host, username=username, password=password)

client.send_command(command='configure firewall transparent')
client.send_command(command='y')
client.send_command(command='configure firewall routed')
client.send_command(command='y')
client.send_command(command='configure manager add 3.38.170.214 cisco123')
print(client.output)
client.disconnect()