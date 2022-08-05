locals {
  account_id          = var.account_id
  issuer_host_path    = trim(var.issuer_url, "https://")
  provider_arn        = "arn:aws:iam::${local.account_id}:oidc-provider/${local.issuer_host_path}"
  aws_iam_path_prefix = var.aws_iam_path_prefix == "" ? null : var.aws_iam_path_prefix
  k8s_namespace       = var.k8s_namespace
  service_account_arn = "system:serviceaccount:${local.k8s_namespace}:${var.service_account}"
}
