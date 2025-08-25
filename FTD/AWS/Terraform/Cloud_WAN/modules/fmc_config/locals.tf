locals {
  instance_names = [for i in range(var.inscount) : "FTD-${i + 1}"]
  ftd_inside_gw  = [for i in range(var.inscount) : "${join(".", slice(split(".", var.ftd_inside_ips[i]), 0, 3))}.1"]
  ftd_outside_gw = [for i in range(var.inscount) : "${join(".", slice(split(".", var.ftd_outside_ips[i]), 0, 3))}.1"]
}