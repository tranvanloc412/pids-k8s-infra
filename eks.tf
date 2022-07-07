module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name                    = join("-", [local.prefix, "eks"])
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa                     = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = var.kms_key_id
    resources        = ["secrets"]
  }]

  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnets

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  #Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    disk_size      = 50
    instance_types = ["t3.medium"]

    attach_cluster_primary_security_group = true
    vpc_security_group_ids                = [aws_security_group.additional.id]
  }

  eks_managed_node_groups = {
    # blue = {
    # }
    green = {
      min_size     = 0
      max_size     = 2
      desired_size = 1

      instance_types = var.node_instance_types
      capacity_type  = "SPOT"

      # labels = {
      #   Environment = "test"
      #   GithubRepo  = "terraform-aws-eks"
      #   GithubOrg   = "terraform-aws-modules"
      # }

      # taints = {
      #   dedicated = {
      #     key    = "dedicated"
      #     value  = "gpuGroup"
      #     effect = "NO_SCHEDULE"
      #   }
      # }

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }

      description = "EKS managed node group example launch template"

      ebs_optimized           = true
      vpc_security_group_ids  = [aws_security_group.additional.id]
      disable_api_termination = false
      enable_monitoring       = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            kms_key_id            = var.kms_key_id
            delete_on_termination = true
          }
        }
      }

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }

      create_iam_role          = true
      iam_role_name            = join("-", [local.prefix, "mangaged", "node", "group"])
      iam_role_use_name_prefix = false
      iam_role_description     = "EKS managed node group"
      iam_role_tags = {
        Purpose = "Protector of the kubelet"
      }
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      ]

      # create_security_group          = true
      # security_group_name            = "eks-managed-node-group-complete-example"
      # security_group_use_name_prefix = false
      # security_group_description     = "EKS managed node group complete example security group"
      # security_group_rules = {
      #   phoneOut = {
      #     description = "Hello CloudFlare"
      #     protocol    = "udp"
      #     from_port   = 53
      #     to_port     = 53
      #     type        = "egress"
      #     cidr_blocks = ["1.1.1.1/32"]
      #   }
      #   phoneHome = {
      #     description                   = "Hello cluster"
      #     protocol                      = "udp"
      #     from_port                     = 53
      #     to_port                       = 53
      #     type                          = "egress"
      #     source_cluster_security_group = true # bit of reflection lookup
      #   }
      # }
      # security_group_tags = {
      #   Purpose = "Protector of the kubelet"
      # }
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::66666666666:role/role1"
  #     username = "role1"
  #     groups   = ["system:masters"]
  #   },
  # ]

  # aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user1"
  #     username = "user1"
  #     groups   = ["system:masters"]
  #   }
  # ]

  # aws_auth_accounts = [
  #   "777777777777",
  #   "888888888888",
  # ]

  tags = local.tags
}


resource "aws_security_group" "additional" {
  name_prefix = join("-", [local.prefix, "additional"])
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = var.myip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
