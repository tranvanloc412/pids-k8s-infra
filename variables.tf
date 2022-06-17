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
  default     = ["27.78.39.216/32"]
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
  default = ["t3.large", "t3.medium", "m6i.large", "m5.large", "m5n.large", "m5zn.large"]
}