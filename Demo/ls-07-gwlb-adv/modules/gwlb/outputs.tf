# Copyright (c) 2022 Cisco Systems, Inc. and its affiliates
# All rights reserved.

output "gwlb" {
  description = "ARN of the gateway loadbalancer"
  value       = aws_lb.gwlb.*.arn
}