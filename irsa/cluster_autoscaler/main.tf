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
  description           = "Permissions required by the CLuster AUtoscaler to do it's job."
  path                  = local.aws_iam_path_prefix
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.eks_oidc_assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/pids-prod-eks"
      values   = ["owned"]
    }
  }
}

resource "aws_iam_policy" "this" {
  name        = var.service_account
  description = "Permissions that are required to manage AWS resource."
  path        = local.aws_iam_path_prefix
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}
