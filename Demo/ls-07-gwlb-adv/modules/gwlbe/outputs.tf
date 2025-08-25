# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

output "gwlbe_rt_id" {
  description = "Gateway loadbalancer Endpoint subnet route table ID"
  value       = aws_route_table.gwlbe_route.*.id
}

output "gwlb_endpoint_id" {
  description = "gwlb vpc endpoint"
  value       = aws_vpc_endpoint.gwlbe.*.id
}