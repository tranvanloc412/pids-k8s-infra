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
  description           = "Permissions required by the Hashicorpt Vault to do it's job."
  path                  = local.aws_iam_path_prefix
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.eks_oidc_assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]

    resources = ["arn:aws:kms:ap-southeast-1:808059214513:key/420d784b-fa72-4914-ab28-0fad425a2ca7"]
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
