locals {
  name = "${var.project_name}-${var.environment}"
  tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

module "vpc" {
  source = "./modules/vpc"

  name                 = local.name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway # 💰 keep this true unless you need multi-AZ HA
  tags                 = local.tags
}

module "ecr" {
  source = "./modules/ecr"

  repository_name            = "${local.name}-app"
  expire_untagged_after_days = var.ecr_expire_untagged_after_days
  tags                       = local.tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name              = "${local.name}-eks"
  cluster_version           = var.cluster_version
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  public_subnet_ids         = module.vpc.public_subnet_ids
  node_instance_types       = var.node_instance_types
  capacity_type             = var.capacity_type # 💰 switch to ON_DEMAND only if Spot capacity is unavailable
  desired_size              = var.desired_size
  min_size                  = var.min_size
  max_size                  = var.max_size
  endpoint_public_access    = var.endpoint_public_access
  public_access_cidrs       = var.public_access_cidrs
  enabled_cluster_log_types = var.enabled_cluster_log_types
  tags                      = local.tags
}
