locals {
  azs             = length(var.azs) > 0 ? var.azs : data.aws_availability_zones.available[0].names
  az_distribution = chunklist(sort(flatten(chunklist(setproduct(range(var.instances), local.azs), var.instances)[0])), var.instances)[1]
  az_distinct     = distinct(local.az_distribution)
  vpc_cidr        = var.vpc_id != "" ? data.aws_vpc.selected[0].cidr_block : var.vpc_cidr
  subnet_newbits  = var.subnet_size - tonumber(split("/", local.vpc_cidr)[1])
}