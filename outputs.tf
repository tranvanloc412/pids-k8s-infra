output "eks_cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "irsa_process_service" {
  value = module.irsa_process_service.sqs_role
}