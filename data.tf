########################################
# Data sources
########################################
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_eks_cluster" "target" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = module.eks.cluster_id
}

# Computed variables
locals {
  prefix          = "${var.project}-${var.env}"
  account_id      = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.name
  cluster_version = "1.22"

  tags = {
    Terraform  = "true"
    Region     = var.region
    Project    = var.project
    GithubRepo = "pids-k8s-infra"
    GithubOrg  = "tranvanloc412"
  }
}
