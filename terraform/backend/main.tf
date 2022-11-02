terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project
      Environment = terraform.workspace
      Application = var.application
    }
  }
}

locals {
  name_prefix = "${var.project}-${terraform.workspace}-${var.application}"
}

# AWS S3
resource "aws_s3_bucket" "this" {
  bucket        = lower("${local.name_prefix}-bucket")
  force_destroy = true
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# AWS DynamoDB
resource "aws_dynamodb_table" "this" {
  name         = "${local.name_prefix}-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.dynamodb_lock_name

  attribute {
    name = var.dynamodb_lock_name
    type = "S"
  }
}
