# terraform-aws-eks-tf-course

Opinionated, cost-optimized Terraform module that stands up a complete,
minimal EKS platform on AWS: a VPC, an ECR repository, and an EKS cluster
with a Spot-backed managed node group.

It composes three nested modules — [`modules/vpc`](modules/vpc),
[`modules/ecr`](modules/ecr), [`modules/eks`](modules/eks) — each usable on
its own, or together through the root module shown below.

## Usage

```hcl
module "eks_platform" {
  source = "github.com/devops-avinashsain/terraform-aws-eks-tf-course"

  project_name = "my-app"
  environment  = "dev"
  aws_region   = "us-east-1"
}
```

See [`examples/complete`](examples/complete) for a full, deployable
configuration (provider + S3 backend + module call).

## What this does NOT include

This module has no `backend` or `provider` block — those belong to the
root configuration that calls it (see `examples/complete`). A reusable
module must never pin its own backend.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6 |
| aws | ~> 6.0 |

## Inputs

| Name | Description | Default |
|------|-------------|---------|
| project_name | Name prefix applied to all resources | `"devops-eks-cicd"` |
| environment | Environment name | `"dev"` |
| aws_region | Used only to build the `configure_kubectl` output | `"us-east-1"` |
| vpc_cidr | CIDR block for the VPC | `"10.0.0.0/16"` |
| azs | AZs to use; empty = auto-pick first 2 in the region | `[]` |
| public_subnet_cidrs | Public subnet CIDRs | `["10.0.101.0/24", "10.0.102.0/24"]` |
| private_subnet_cidrs | Private subnet CIDRs | `["10.0.1.0/24", "10.0.2.0/24"]` |
| single_nat_gateway | One shared NAT instead of one per AZ | `true` |
| ecr_expire_untagged_after_days | Days before untagged ECR images expire | `3` |
| cluster_version | EKS Kubernetes version | `"1.31"` |
| node_instance_types | Worker node instance types | `["t3.medium"]` |
| capacity_type | `SPOT` or `ON_DEMAND` | `"SPOT"` |
| desired_size / min_size / max_size | Node group scaling | `1` / `1` / `2` |
| endpoint_public_access | Expose the EKS API endpoint publicly | `true` |
| public_access_cidrs | CIDRs allowed to reach the public endpoint | `["0.0.0.0/0"]` |
| enabled_cluster_log_types | Control plane log types to enable | `[]` |
| tags | Extra tags merged into every resource | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| private_subnet_ids / public_subnet_ids | Subnet IDs |
| ecr_repository_url | ECR repository URL |
| eks_cluster_name | EKS cluster name |
| eks_cluster_endpoint | EKS API endpoint |
| configure_kubectl | Ready-to-run `aws eks update-kubeconfig` command |

## Notes for a production environment

This is tuned for a low-cost dev/learning deployment. Before reusing it for
staging/prod, revisit:

- `endpoint_public_access` / `public_access_cidrs` — restrict to a known
  CIDR or disable public access if you only connect from inside the VPC.
- `enabled_cluster_log_types` — enable `["api", "audit"]` for an audit trail.
- EKS secrets encryption (`encryption_config`) — not configured here.
- `single_nat_gateway` — set to `false` for multi-AZ NAT redundancy.

## Publishing to the Terraform Registry

1. Keep this repo public and named `terraform-aws-eks-tf-course`
   (registry convention: `terraform-<PROVIDER>-<NAME>`).
2. Tag releases with semver, e.g. `git tag v0.1.0 && git push --tags`.
3. Connect the repo at <https://registry.terraform.io/github/publish>.
