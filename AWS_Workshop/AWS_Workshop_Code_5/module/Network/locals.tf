locals {
  con = var.vpc_cidr != "" ? aws_vpc.asa_vpc[0].id : data.aws_vpc.asa_vpc[0].id
  instances = var.availability_zone_count * var.instances_per_az
  mgmt_subnet = var.mgmt_subnet_cidr != [] ? aws_subnet.mgmt_subnet : data.aws_subnet.mgmt
  inside_subnet = var.inside_subnet_cidr != [] ? aws_subnet.inside_subnet : data.aws_subnet.insideftd
  outside_subnet = var.outside_subnet_cidr != [] ? aws_subnet.outside_subnet : data.aws_subnet.outsideftd
  diag_subnet = var.diag_subnet_cidr != [] ? aws_subnet.diag_subnet : data.aws_subnet.diagftd
  azs = chunklist(sort(flatten(chunklist(setproduct(range(local.instances), range(1, (var.availability_zone_count + 1))), local.instances)[0])), local.instances)[1]
}
