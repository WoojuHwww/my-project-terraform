output "cluster_autoscaler_role_arn" {
  value = aws_iam_role.cluster_autoscaler.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "platform_admin_role_arn" {
  value = var.create_platform_admin_role ? aws_iam_role.platform_admin[0].arn : null
}