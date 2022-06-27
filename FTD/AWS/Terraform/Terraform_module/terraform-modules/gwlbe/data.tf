data "aws_availability_zones" "available" {}

data "aws_subnet" "gwlbe" {
  count = var.gwlbe_subnet_cidr == [] ? length(var.gwlbe_subnet_name) : 0
  filter {
    name   = "tag:Name"
    values = [var.gwlbe_subnet_name[count.index]]
  }
}
