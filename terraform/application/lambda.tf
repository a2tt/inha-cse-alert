# IAM
resource "aws_iam_role" "lambda" {
  name = "${local.name_prefix}-role"

  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

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

# Lambda function
resource "aws_lambda_function" "this" {
  filename         = var.lambda_package_name
  function_name    = "${local.name_prefix}-function"
  role             = aws_iam_role.lambda.arn
  handler          = var.lambda_handler
  source_code_hash = filebase64sha256(var.lambda_package_name)
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  architectures    = ["x86_64"]

  layers = [aws_lambda_layer_version.this.arn]

  depends_on = [
    aws_iam_role_policy_attachment.cloudwatch_logging,
  ]
}

# Lambda layer
resource "aws_lambda_layer_version" "this" {
  filename   = var.lambda_layer_name
  layer_name = "${local.name_prefix}-layer"

  compatible_architectures = ["x86_64"]
  compatible_runtimes      = [var.lambda_runtime]
  source_code_hash         = filebase64sha256(var.lambda_layer_name)
}
