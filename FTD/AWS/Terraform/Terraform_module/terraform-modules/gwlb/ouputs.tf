output "gwlb" {
  value = aws_lb.gwlb.*.arn
}