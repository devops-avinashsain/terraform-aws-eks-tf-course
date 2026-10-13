# Complete example

Deploys the full platform (VPC + ECR + EKS) using the root module, with a real
S3 backend wired up. This is the config you actually `terraform apply` — the
repo root is consumed as a module, not applied directly.

```bash
# one-time: create the S3 state bucket (see scripts/bootstrap-backend.sh)
terraform init
terraform apply
```
