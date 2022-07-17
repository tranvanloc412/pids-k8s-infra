variable "issuer_url" {
  type    = string
  default = ""
}

variable "sqs_service_account" {
  type    = string
  default = "sqs-processing-sa"
}

variable "k8s_namespace" {
  type    = string
  default = "process-service"
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
