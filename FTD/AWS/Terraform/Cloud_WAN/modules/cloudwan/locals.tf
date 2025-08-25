locals {
  wan_subnet      = [for i in range(var.availability_zone_count) : "${join(".", slice(split(".", var.service_vpc_cidr), 0, 2))}.${60 + i + 1}.0/24"]
  wan_subnet_name = [for i in range(var.availability_zone_count) : "core-network-attachment-${i + 1}"]
}