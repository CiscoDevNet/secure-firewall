data "aws_ami" "ftdv" {
  #most_recent = true      // you can enable this if you want to deploy more
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["${var.FTD_version}*"]
  }

  filter {
    name   = "product-code"
    values = ["a8sxy6easi2zumgtyr564z6y7"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_ami" "fmcv" {
  #most_recent = true      // you can enable this if you want to deploy more
  owners = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["${var.FMC_version}*"]
  }
  filter {
    name   = "product-code"
    values = ["bhx85r4r91ls2uwl69ajm9v1b"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

