terraform {

  cloud {
    organization = "pids"

    workspaces {
      name = "pids-k8s-infra"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }

  required_version = ">= 1.1.0"
}
