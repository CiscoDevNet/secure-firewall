locals {
  gwlbe_subnet      = [for i in range(var.availability_zone_count) : "${join(".", slice(split(".", var.service_vpc_cidr), 0, 2))}.${50 + i + 1}.0/24"]
  gwlbe_subnet_name = [for i in range(var.availability_zone_count) : "gwlbe_subnet${i + 1}"]
}