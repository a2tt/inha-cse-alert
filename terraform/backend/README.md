# Backend Infrastructure

This terraform project is used to create resources that store terraform states remotely.

## Deployment

```bash
# Download Terraform from here: https://www.terraform.io/downloads
ENV=dev
BUCKET_SUFFIX=UniqueIdentifier

terraform init
terraform workspace new $ENV
terraform apply -var "bucket_suffix=$BUCKET_SUFFIX"
```

Note: you should define two variable, `ENV` and `BUCKET_SUFFIX`.
