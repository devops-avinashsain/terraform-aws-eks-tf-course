output "vpc_id" {
  value = module.eks_platform.vpc_id
}

output "ecr_repository_url" {
  value = module.eks_platform.ecr_repository_url
}

output "eks_cluster_name" {
  value = module.eks_platform.eks_cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks_platform.eks_cluster_endpoint
}

output "configure_kubectl" {
  value = module.eks_platform.configure_kubectl
}
