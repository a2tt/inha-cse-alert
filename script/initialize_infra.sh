#!/bin/bash
# Initialize Terraform backend
cd $PROJECT_ROOT/terraform/backend || exit
terraform init
terraform workspace new $ENVIRONMENT
terraform workspace select $ENVIRONMENT
terraform apply || exit

# Initialize Terraform for application
cd $PROJECT_ROOT/terraform/application || exit
terraform init
terraform workspace new $ENVIRONMENT
