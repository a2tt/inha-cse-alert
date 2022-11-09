variable "aws_region" {
  description = "AWS region where resources will be created."
  default     = "ap-northeast-2"
}

variable "bucket_suffix" {
  description = "AWS S3 bucket suffix where tfstate files are stored. It should be globally unique."
}

variable "dynamodb_name_suffix" {
  description = "AWS DynamoDB table name that would be used for state lock."
  default     = "dynamodb"
}

variable "dynamodb_lock_name" {
  description = "AWS DynamoDB lock name."
  default     = "LockID"
}

variable "project" {
  description = "Name of this project."
  default     = "inhaCSENotice"
}

variable "application" {
  description = "Name of this application."
  default     = "terraform"
}
