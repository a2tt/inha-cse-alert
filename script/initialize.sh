#!/bin/bash
REGION="ap-northeast-2"
PROJECT="inhaCSENotice"
PROJECT_LOWERCASE=$(echo "$PROJECT" | tr '[:upper:]' '[:lower:]')
APP="task"

TF_REGION="$REGION"
TF_BUCKET="$PROJECT_LOWERCASE-$ENVIRONMENT-terraform-bucket"
TF_KEY="$APP.tfstate"
TF_DYNAMODB_TABLE="$PROJECT-$ENVIRONMENT-terraform-dynamodb"

# Initialize Terraform backend
cd $PROJECT_ROOT/terraform/backend || exit
terraform init
terraform workspace new $ENVIRONMENT
terraform workspace select $ENVIRONMENT
terraform apply || exit

# Initialize Terraform for application
cd $PROJECT_ROOT/terraform/application || exit

terraform init \
    -backend-config="region=$TF_REGION" \
    -backend-config="bucket=$TF_BUCKET" \
    -backend-config="key=$TF_KEY" \
    -backend-config="dynamodb_table=$TF_DYNAMODB_TABLE"

terraform workspace new $ENVIRONMENT
terraform workspace select $ENVIRONMENT
