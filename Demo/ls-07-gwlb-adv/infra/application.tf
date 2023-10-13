data "template_file" "apache_install" {
  template = file("${path.module}/apache_install.tpl")
}
data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "EC2-Ubuntu1" {
  # depends_on = [ aws_instance.testLinux ]
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  
  user_data = data.template_file.apache_install.rendered
  network_interface {
    network_interface_id = element(module.spoke_network.outside_interface, 0)
    device_index         = 0
  }

  tags = {
    Name = "${var.pod_prefix}-Ec2-Ubuntu1"
  }
}
resource "aws_instance" "EC2-Ubuntu2" {
  # depends_on = [ aws_instance.testLinux ]
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  
  user_data = data.template_file.apache_install.rendered
  network_interface {
    network_interface_id = element(module.spoke_network_2.outside_interface, 0)
    device_index         = 0
  }

  tags = {
    Name = "${var.pod_prefix}-Ec2-Ubuntu2"
  }
}
resource "aws_instance" "EC2-Ubuntu3" {
  # depends_on = [ aws_instance.testLinux ]
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  
  user_data = data.template_file.apache_install.rendered
  network_interface {
    network_interface_id = element(module.spoke_network_3.outside_interface, 0)
    device_index         = 0
  }

  tags = {
    Name = "${var.pod_prefix}-Ec2-Ubuntu3"
  }
}



########################

resource "tls_private_key" "key_pair" {
algorithm = "RSA"
rsa_bits  = 4096
}

resource "local_file" "private_key" {
content       = tls_private_key.key_pair.private_key_openssh
filename      = var.keyname
file_permission = 0700
}

resource "aws_key_pair" "deployer" {
  key_name   = var.keyname
  public_key = tls_private_key.key_pair.public_key_openssh
}