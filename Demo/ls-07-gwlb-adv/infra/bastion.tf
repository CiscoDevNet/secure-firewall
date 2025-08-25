# data "template_file" "bastion_install" {
#   template = file("${path.module}/bastion_install.tpl")
# }

# resource "aws_subnet" "bastion_subnet" {
#   count = 3
#   vpc_id            = local.vpcs[count.index] # module.spoke_network.vpc_id
#   cidr_block        = local.subnet_cidrs[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "bastion-subnet-${count.index+1}}"
#   }
# }

# resource "aws_network_interface" "bastion_interface" {
#   count = 3
#   description       = "bastion-interface-${count.index+1}"
#   subnet_id         = aws_subnet.bastion_subnet[count.index].id
#   source_dest_check = false
#   security_groups   = [aws_security_group.bastion_sg[count.index].id]
# #   private_ips       = [var.bastion_ip]
# }

# resource "aws_route_table" "bastion_route" {
#   count = 3
#   vpc_id = local.vpcs[count.index]
#   tags = {
#     Name = "bastion network Routing table-${count.index+1}"
#   }
# }

# resource "aws_route_table_association" "bastion_association" {
#   count = 3
#   subnet_id      = aws_subnet.bastion_subnet[count.index].id
#   route_table_id = aws_route_table.bastion_route[count.index].id
# }

# # resource "aws_route" "bastion_default_route" {
# #   count = 3
# #   route_table_id         = aws_route_table.bastion_route[count.index].id
# #   destination_cidr_block = "0.0.0.0/0"
# #   gateway_id             = local.igws[count.index]
# # }

# resource "aws_instance" "testLinux" {
#   count = 3
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   key_name      = "kadadhic-Nvirginia"
#   user_data = data.template_file.bastion_install.rendered
#   network_interface {
#     network_interface_id = aws_network_interface.bastion_interface[count.index].id
#     device_index         = 0
#   }

#   tags = {
#     Name = "bastion-linux-${count.index+1}"
#   }
# }

# resource "aws_security_group" "bastion_sg" {
#   count = 3
#   name        = "Allow All Bastion ${count.index+1}"
#   description = "Allow all traffic"
#   vpc_id      = local.vpcs[count.index]

#   ingress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }
# }


# ##############################


