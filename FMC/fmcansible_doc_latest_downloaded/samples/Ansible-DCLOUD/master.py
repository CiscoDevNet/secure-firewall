import os
start = int(input("Run from: "))
end = int(input("Run to: "))

files = [ "echo 1st scenario is manual", "ansible-playbook -i host.yml 2_objects.yml >/dev/null 2>&1", "ansible-playbook -i host.yml 3_security_zones.yml >/dev/null 2>&1", "ansible-playbook -i host.yml 4_acc_policy.yml >/dev/null 2>&1", "ansible-playbook -i host.yml 5_1a_device_unreg.yml >/dev/null 2>&1", "echo 6th scenario is manual", "ansible-playbook -i host.yml 7_device_interface.yml >/dev/null 2>&1"]

for x in range(start-1, end):
    init = "echo 'Running Scenario {test} ...'".format(test = x+1)
    os.system(init)
    if x == 4:
        os.system(files[x])
        os.system('python3 5_1b_conf_man.py >/dev/null 2>&1')
        os.system('echo "Waiting for 4 mins for device to get registered..... "')
        os.system('ansible-playbook -i host.yml 5_2_device_reg.yml >/dev/null 2>&1')
    else:
        os.system(files[x])
    
if end >= 3:
    os.system('echo "Task 2:Creating a new Variable Set in 3rd scenario needs to be done manually"')
