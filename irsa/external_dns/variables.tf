variable "issuer_url" {
  type = string
}

variable "service_account" {
  type    = string
  default = "external-dns"
}

variable "k8s_namespace" {
  description = "Kubernetes namespace to deploy the AWS ALB Ingress Controller into."
  type        = string
  default     = "external-dns"
}

variable "aws_iam_path_prefix" {
  description = "Prefix to be used for all AWS IAM objects."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common AWS tags to be applied to all AWS objects being created."
  type        = map(string)
  default     = {}
}

variable "account_id" {
  type    = string
  default = ""
}
