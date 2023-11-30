####################
# Cloudwatch Events and SNS Notifications
####################

resource "aws_sns_topic" "user_notify_topic" {
  name = join("-", [aws_autoscaling_group.ftdv-asg.name, "UserNotifyTopic"])
}

resource "aws_sns_topic" "as_manager_topic" {
  name = join("-", [aws_autoscaling_group.ftdv-asg.name, "autoscale-manager-topic"])
}

resource "aws_sns_topic_subscription" "user_notify_topic_subscription" {
  endpoint  = var.notify_email
  protocol  = "email"
  topic_arn = aws_sns_topic.user_notify_topic.arn
}

resource "aws_sns_topic_subscription" "as_manager_topic_subscription" {
  protocol  = "lambda"
  endpoint  = aws_lambda_function.autoscale_manager.arn
  topic_arn = aws_sns_topic.as_manager_topic.arn
}

# Lambda SNS Triggers

resource "aws_lambda_permission" "cloudwatch_sns_autoscale" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.autoscale_manager.function_name
  principal = "sns.amazonaws.com"
  source_arn = aws_sns_topic.as_manager_topic.arn
}

# Cloudwatch Events Rules

resource "aws_cloudwatch_event_rule" "instance_event" {
  name          = join("-", [aws_autoscaling_group.ftdv-asg.name, "notify-instance-event"])
  event_pattern = <<EOF
  {
    "source": [
      "aws.autoscaling"
    ],
    "detail-type": [
      "EC2 Instance Launch Successful",
      "EC2 Instance Terminate Successful"
    ],
    "detail": {
      "AutoScalingGroupName": [
        "${aws_autoscaling_group.ftdv-asg.name}"
      ]
    }
  }
EOF
}

resource "aws_cloudwatch_event_rule" "instance_launch_event" {
  name          = join("-", [aws_autoscaling_group.ftdv-asg.name, "instance-launch-event"])
  event_pattern = <<EOF
  {
    "source": [
      "aws.autoscaling"
    ],
    "detail-type": [
      "EC2 Instance Launch Successful"
    ],
    "detail": {
      "AutoScalingGroupName": [
        "${aws_autoscaling_group.ftdv-asg.name}"
      ]
    }
  }
EOF
}

resource "aws_cloudwatch_event_rule" "lifecycle_event" {
  name          = join("-", [aws_autoscaling_group.ftdv-asg.name, "lifecycle-action"])
  event_pattern = <<EOF
  {
    "source": [
      "aws.autoscaling"
    ],
    "detail-type": [
      "EC2 Instance-launch Lifecycle Action",
      "EC2 Instance-terminate Lifecycle Action"
    ],
    "detail": {
      "AutoScalingGroupName": [
        "${aws_autoscaling_group.ftdv-asg.name}"
      ]
    }
  }
EOF
}


resource "aws_cloudwatch_event_rule" "health_doctor_cron" {
  name                = join("-", [aws_autoscaling_group.ftdv-asg.name, "health-doc-cron"])
  schedule_expression = "rate(${60} minutes)"
}

# Cloudwatch Targets

resource "aws_cloudwatch_event_target" "health_doctor_cron" {
  rule      = aws_cloudwatch_event_rule.health_doctor_cron.name
  arn       = aws_lambda_function.autoscale_manager.arn
}

resource "aws_cloudwatch_event_target" "lifecycle" {
  rule      = aws_cloudwatch_event_rule.lifecycle_event.name
  arn       = aws_lambda_function.lifecycle_ftdv.arn
}
/*
resource "aws_cloudwatch_event_target" "instance_launch" {
  rule      = aws_cloudwatch_event_rule.instance_launch_event.name
  arn       = aws_lambda_function.custom_metric_fmc.arn
}
*/
resource "aws_cloudwatch_event_target" "instance_event" {
  rule      = aws_cloudwatch_event_rule.instance_event.name
  arn       = aws_lambda_function.autoscale_manager.arn
}


# Lambda Event Triggers

resource "aws_lambda_permission" "cloudwatch_instance_event" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.autoscale_manager.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.instance_event.arn
}

resource "aws_lambda_permission" "health_doc_cron" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.autoscale_manager.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.health_doctor_cron.arn
}

resource "aws_lambda_permission" "cloudwatch_instance_lifecycle" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lifecycle_ftdv.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.lifecycle_event.arn
}

# Cloudwatch Log Groups

resource "aws_cloudwatch_log_group" "autoscale_manager" {
  name = "/aws/lambda/${aws_lambda_function.autoscale_manager.function_name}"

  retention_in_days = 30
}

/*
resource "aws_cloudwatch_log_group" "custom_metric_fmc" {
  name = "/aws/lambda/${aws_lambda_function.custom_metric_fmc.function_name}"

  retention_in_days = 30
}
*/
resource "aws_cloudwatch_log_group" "lifecycle_ftdv" {
  name = "/aws/lambda/${aws_lambda_function.lifecycle_ftdv.function_name}"

  retention_in_days = 30
}



