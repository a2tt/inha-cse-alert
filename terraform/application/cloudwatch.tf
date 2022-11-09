# IAM for Lambda
resource "aws_iam_policy" "cloudwatch_logging" {
  name        = "${local.name_prefix}-policy-cloudwatchLogging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logging" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.cloudwatch_logging.arn
}

# Cloudwatch log group
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${local.name_prefix}-function"
  retention_in_days = 14
}
