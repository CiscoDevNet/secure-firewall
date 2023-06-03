locals {
  con = var.vpc_cidr != null ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
}