# Cisco Secure Firewall Gateway load balancer for AWS

Terraform Module to deploy Gateway Loadbalancer with 'n' number of Cisco Secure FTD instances as targets in AWS

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.7.0 |

## Modules

No Modules.

## Resources

| Name | Type |
|------|------|
| aws_lb | resource |
| aws_lb_target_group | resource |
| aws_lb_listener | resource |
| aws_lb_target_group_attachment | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gwlb_name"></a> [gwlb\_name](#input\_gwlb\_name) | name for Gateway loadbalancer | `string` | n/a | yes |
| <a name="input_instance_ip"></a> [instance\_ip](#input\_instance\_ip) | list of instance ip address that will be attached to target group of GWLB | `list(string)` | `[]` | no |
| <a name="input_gwlb_subnet"></a> [gwlb\_subnet](#input\_gwlb\_subnet) | GWLB subnet | `list(string)` | n/a | yes |
| <a name="input_gwlb_vpc_id"></a> [gwlb\_vpc\_id](#input\_gwlb\_vpc\_id) | GWLB vpc id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gwlb"></a> [gwlb](#output\_gwlb) | ARN of the gateway loadbalancer |