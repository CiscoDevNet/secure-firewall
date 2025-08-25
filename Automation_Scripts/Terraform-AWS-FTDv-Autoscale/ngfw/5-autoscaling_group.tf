##################
# Autoscaling
##################

resource "aws_autoscaling_group" "ftdv-asg" {
  availability_zones        = [var.aws_az]
  name                      = "gwlb-asg"
  max_size                  = var.auto_scale_max_group_size
  min_size                  = var.auto_scale_min_group_size
  desired_capacity          = var.auto_scale_desired_group_size
  health_check_grace_period = 900
  health_check_type         = "ELB"
  force_delete              = false
  termination_policies      = ["NewestInstance"]
  enabled_metrics           = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
    "GroupStandbyInstances"
  ]


  metrics_granularity = "1Minute"
  launch_template {
    id      = aws_launch_template.ftd_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_lifecycle_hook" "launch_lifecycle_hook" {
  name                   = "Launch_LifecycleHook"
  autoscaling_group_name = aws_autoscaling_group.ftdv-asg.name
  default_result         = "ABANDON"
  heartbeat_timeout      = 240
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
}

resource "aws_autoscaling_lifecycle_hook" "terminate_lifecycle_hook" {
  name                   = "Terminate_LifecycleHook"
  autoscaling_group_name = aws_autoscaling_group.ftdv-asg.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 120
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
}