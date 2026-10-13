variable "project_name" {
  description = "Name prefix applied to all resources (VPC, ECR, EKS)"
  type        = string
  default     = "devops-eks-cicd"
}

variable "environment" {
  description = "Environment name, e.g. dev, staging, prod"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region, used only to build the configure_kubectl output"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to use (keep to 2 for cost — EKS requires min 2). Leave empty to auto-pick the first 2 available AZs in the current region."
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "single_nat_gateway" {
  description = "Use one shared NAT gateway instead of one per AZ (cost optimization)"
  type        = bool
  default     = true
}

variable "ecr_expire_untagged_after_days" {
  description = "Days after which untagged ECR images are expired"
  type        = number
  default     = 3
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.31"
}

variable "endpoint_public_access" {
  description = "Whether the EKS public API endpoint is enabled"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public API endpoint (only used when endpoint_public_access is true)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  description = "EKS control plane log types to enable, e.g. [\"api\", \"audit\"]"
  type        = list(string)
  default     = []
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "SPOT (cheap, default) or ON_DEMAND"
  type        = string
  default     = "SPOT"
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Extra tags merged into every resource, on top of Project/Environment/ManagedBy"
  type        = map(string)
  default     = {}
}
