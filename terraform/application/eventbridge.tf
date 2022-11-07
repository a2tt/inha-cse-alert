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
