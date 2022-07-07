# https://github.com/kubernetes-sigs/external-dns

data "aws_iam_policy_document" "eks_oidc_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${local.issuer_host_path}:sub"
      values   = [local.service_account_arn]
    }
    principals {
      identifiers = [local.provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.service_account
  description           = "Permissions required by the Kubernetes AWS ALB Ingress controller to do it's job."
  path                  = local.aws_iam_path_prefix
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.eks_oidc_assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = ["arn:aws:route53:::hostedzone/*"]
  }
}

resource "aws_iam_policy" "this" {
  name        = var.service_account
  description = "Permissions that are required to manage AWS Route53."
  path        = local.aws_iam_path_prefix
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}
