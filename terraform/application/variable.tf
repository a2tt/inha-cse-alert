variable "aws_region" {
  description = "AWS region where resources are to be created."
  default     = "ap-northeast-2"
}

variable "project" {
  description = "Name of this project."
  default     = "inhaCSENotice"
}

variable "application" {
  description = "Name of this application."
  default     = "task"
}

# AWS Lambda
variable "lambda_handler" {
  description = "AWS Lambda function entrypoint. (e.g. filename.function_name)"
  default     = "handler.board_crawler"
}

variable "lambda_package_name" {
  description = "Zipped package name."
  default     = "application.zip"
}

variable "lambda_package_type" {
  description = "AWS Lambda package type. (e.g. Zip, or Image)"
  default     = "Zip"
}

variable "lambda_runtime" {
  description = "AWS Lambda runtime listed in https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime."
}

variable "lambda_timeout" {
  description = "AWS Lambda timeout in seconds."
  type        = number
  default     = 300
}

variable "lambda_layer_name" {
  description = "Zipped layer name."
  default     = "lambda_layer.zip"
}

# AWS S3
variable "article_bucket_name" {
  description = "AWS S3 bucket name where notice articles are stored. It should be same with the bucket name you specified in application/configs.yml"
}

# AWS EventBridge
variable "event_schedule" {
  description = "Cron expression for schedule."
}
