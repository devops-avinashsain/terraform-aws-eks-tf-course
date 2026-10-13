module "eks_platform" {
  source = "../.."

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
}
