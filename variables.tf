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

variable "myip" {
  default     = ["115.74.21.240/32"]
}

variable "kms_key_id" {
  default = null
}

variable "vpc_id" {
  default = null
}
variable "public_subnets" {
  default = null
}

variable "node_instance_types" {
  default = ["t3.large", "t3.medium"]
}