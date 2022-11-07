terraform {
  backend "s3" {
    # FIXME: configure dynamically
    bucket         = "inhacsenotice-dev-terraform-bucket"
    key            = "inhaCSENotice-dev-task.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "inhaCSENotice-dev-terraform-dynamodb"
  }

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
