data "aws_ami" "asav" {
  most_recent = true // you can enable this if you want to deploy more
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["${var.ASA_version}*"]
  }

  # filter {
  #   name   = "product-code"
  #   values = ["663uv4erlxz65quhgaz9cida0"]
  # }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "asa_startup_file" {
  template = file("${path.module}/asa_startup_file.txt")
}

data "aws_availability_zones" "available" {}