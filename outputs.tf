output "ci_vpc_id" {
  description = "The ID of the CI VPC"
  value = module.ci_vpc.vpc_id
}

output "ci_vpc_cidr_block" {
  description = "The CIDR block of the CI VPC"
  value = module.ci_vpc.vpc_cidr_block
}

output "ci_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.ci_vpc.private_subnets
}

output "ci_public_subnets" {
  description = "List of IDs of private subnets"
  value       = module.ci_vpc.public_subnets
}
