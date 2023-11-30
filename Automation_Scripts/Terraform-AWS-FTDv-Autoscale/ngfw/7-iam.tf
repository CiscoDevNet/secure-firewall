# IAM Polcies

resource "aws_iam_role" "lambda_role" {
  name               = join("-", [aws_autoscaling_group.ftdv-asg.name, "Role"])
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "lambda.amazonaws.com"
            ]
          },
          "Action" : [
            "sts:AssumeRole"
          ]
        }
      ]
    })
  path = "/"
}

resource "aws_iam_policy" "lambda_policy" {
  name   = join("-", [aws_autoscaling_group.ftdv-asg.name, "Policy"])
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:*",
            "ec2:*",
            "elasticloadbalancing:*",
            "autoscaling:*",
            "events:*",
            "s3:*",
            "cloudwatch:*",
            "cloudwatch:SetAlarmState",
            "cloudwatch:PutMetricData",
            "sns:*",
            "ssm:*",
            "lambda:*",
            "kms:Decrypt"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

# Execution role and policies for the lifecycle hook
resource "aws_iam_role" "lifecycle_hook" {
  name               = "${var.env_name}-lifecycle-role"
  assume_role_policy = data.aws_iam_policy_document.asg_assume.json
}

resource "aws_iam_role_policy" "lifecycle_hook" {
  name   = "${var.env_name}-lifecycle-asg-permissions"
  role   = aws_iam_role.lifecycle_hook.id
  policy = data.aws_iam_policy_document.asg_permissions.json
}

data "aws_iam_policy_document" "asg_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "asg_permissions" {
  statement {
    effect = "Allow"

    resources = [
      aws_sns_topic.as_manager_topic.arn,
    ]

    actions = [
      "sns:Publish",
    ]
  }
}

