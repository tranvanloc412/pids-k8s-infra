module "irsa_process_service" {
  source = "./irsa/process_service"

  account_id = local.account_id
  issuer_url = data.aws_eks_cluster.target.identity[0].oidc[0].issuer
  tags       = local.tags

  depends_on = [module.eks]
}
