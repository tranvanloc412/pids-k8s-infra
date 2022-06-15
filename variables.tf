# Environment
variable "env" {
  description = "Environment"
  default     = "ci"
}

variable "project" {
  description = "Project name"
  default     = "pids"
}

variable "region" {
  description = "AWS region"
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Available zones"
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "private_subnets" {
  description = "Private Subnets CIDR"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "Public Subnets CIDR"
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}
