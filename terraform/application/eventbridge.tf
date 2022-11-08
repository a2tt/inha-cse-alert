# Bus
data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}

# Rule
resource "aws_cloudwatch_event_rule" "cron" {
  name        = "${local.name_prefix}-eventBridgeRule"
  description = "Trigger Lambda periodically."

  schedule_expression = var.event_schedule
  is_enabled          = true
}

# Target
resource "aws_cloudwatch_event_target" "task" {
  rule           = aws_cloudwatch_event_rule.cron.id
  event_bus_name = data.aws_cloudwatch_event_bus.default.arn
  arn            = aws_lambda_function.this.arn
}

# IAM policy for Lambda to be triggered by eventbridge
resource "aws_iam_policy" "eventbridge_target" {
  name        = "${local.name_prefix}-policy-eventbridgeTarget"
  path        = "/"
  description = "IAM policy to allow eventbridge to trigger lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:SourceArn": "${aws_cloudwatch_event_rule.cron.arn}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eventbridge_target" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.eventbridge_target.arn
}
