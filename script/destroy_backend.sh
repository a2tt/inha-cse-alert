#!/bin/bash
cd "$PROJECT_ROOT/terraform/backend" || exit
terraform workspace select "$ENVIRONMENT" &&
    terraform destroy || exit
