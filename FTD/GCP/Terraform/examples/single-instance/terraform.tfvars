#OOB management
cisco_product_version = "cisco-ftdv-7-3-0-69"
project_id            = "gcp-netsecgcptenant-nprd-79235"//"cisco-asa-terraform"
region                = "us-west1"
vm_zones              = ["us-west1-a"]
vm_machine_type       = "c2-standard-8"
vm_instance_labels = {
  firewall    = "ftd"
  environment = "dev"
}
hostname          = "cisco-ftd"
day_0_config      = "startup_file.json"
admin_ssh_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGMoD3F/swRm13iFbvO6rL+qmtnWUsWHcKOlma0G41zYN0LMGAfX0xatPap540vRhw8CEAN32FRkAGqu0CVCOTyWw1iAswMrulLdNbYubjLBpMBQ2IA/fOc5GDhriPo0yBqEbqvctJFnL23WoSZAPOjyvQ+yDqGSqFL9CH8TFS19SPfw8Wf3BOhRya3iXoAvBVYA92CdzFHh+lneFLiawOwHR2M6eFxIsN2ZF7zIlHx3WAWyaH4YaWtnt87oGrafNygdowfbxQ5o4X4OAytWUKUbOQ3n8q4YX37XB46DyahFvTK5de3JQFVnKeN9bm2emRr7KJu5ZrMrKFa1eWGJmDgJPM8ZAyCHXKr1lorJEI15A5FDhp7Mdb+a4DrqbKSLAAsy6u4364gz8FhKbrsBOw87HZmu/s1BYLbXgOHlZEs69iEAQsWjwoyMm/gkLlxzSGncnmSueQNaTuA0Ncg2QGB5uzYv+R7M3c4UNN2p8iUQA9qu95UW5+WajiejrBMGU= kgreeshm@KGREESHM-M-L30G"//"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCII2+Zvw/Var0aEo7B5FMGSmLSByanSeoNyp15ztOl7hsvL7c52kPnF+O288cBTDSJCTHJ3gGp18h0daXlhV8ab6gsQFP+HZtuH60+93Pt+IFMzRq4fT5pY2wYLXQ1Cahkj6rZlrjHGRwDr0mi42TR5i9QiOvWtNAUH0L7RNywvntyWjU2l+bJ/SKJ1rGK1GsNUvTJmk9+vE/JXPfrBqHe3yTrR4vGUa8QRx+x3hiZ32WPvCBKIdKMSdO/hYIs08m/npV1MIQJJZq9ZcCFkFxFGyJ1q4mdoXCSby7SHuqqxzrEEIYSQWixOcDdsNR57RufgjWdM9KwcVODTYaiDbf admin@starship.matrix.com"
admin_password    = "C8Npp2E61Az@6z3L"
num_instances     = 1
# nic0 is the management interface
networks = [
  {
    name         = "vpc-mgmt"
    cidr         = "10.10.0.0/24"
    appliance_ip = ["10.10.0.10"]
    external_ip  = true
  },
  {
    name         = "vpc-diag"
    cidr         = "10.10.1.0/24"
    appliance_ip = ["10.10.1.10"]
    external_ip  = false
  },
  {
    name         = "vpc-outside"
    cidr         = "10.10.2.0/24"
    appliance_ip = ["10.10.2.10"]
    external_ip  = true
  },
  {
    name         = "vpc-inside"
    cidr         = "10.10.3.0/24"
    appliance_ip = ["10.10.3.10"]
    external_ip  = false
  },
  {
    name         = "vpc-dmz"
    cidr         = "10.10.4.0/24"
    appliance_ip = ["10.10.4.10"]
    external_ip  = false
  }
]
mgmt_network    = "vpc-mgmt"
inside_network  = "vpc-inside"
outside_network = "vpc-outside"
dmz_network     = "vpc-dmz"
diag_network    = "vpc-diag"