module "irsa_process_service" {
  source = "./irsa/process_service"

  account_id = local.account_id
  issuer_url = data.aws_eks_cluster.target.identity[0].oidc[0].issuer
  tags       = local.tags

  depends_on = [module.eks]
}

module "irsa_alb_ingress_controller" {
  source = "./irsa/alb_ingress_controller"

  account_id = local.account_id
  issuer_url = data.aws_eks_cluster.target.identity[0].oidc[0].issuer
  tags       = local.tags

  depends_on = [module.eks]
}

module "irsa_external_dns" {
  source = "./irsa/external_dns"

  account_id = local.account_id
  issuer_url = data.aws_eks_cluster.target.identity[0].oidc[0].issuer
  tags       = local.tags

  depends_on = [module.eks]
}

module "irsa_vault" {
  source = "./irsa/vault"

  account_id = local.account_id
  issuer_url = data.aws_eks_cluster.target.identity[0].oidc[0].issuer
  tags       = local.tags

  depends_on = [module.eks]
}

module "irsa_cluster_autoscaler" {
  source = "./irsa/cluster_autoscaler"

  account_id = local.account_id
  issuer_url = data.aws_eks_cluster.target.identity[0].oidc[0].issuer
  tags       = local.tags

  depends_on = [module.eks]
}