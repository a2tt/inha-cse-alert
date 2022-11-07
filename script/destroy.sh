#!/bin/bash
cd "$PROJECT_ROOT/terraform/application" || exit
terraform workspace select "$ENVIRONMENT" &&
    terraform destroy || exit
