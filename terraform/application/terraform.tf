terraform {
  backend "s3" {}

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
