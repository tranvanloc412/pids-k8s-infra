########################################
# Data sources
########################################
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Computed variables
locals {
  prefix     = "${var.project}-${var.env}"
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  tags = {
    Terraform = "true"
    Region    = var.region
    Project   = var.project
  }
}
