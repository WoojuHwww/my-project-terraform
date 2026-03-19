data "tls_certificate" "eks_oidc" {
  url = var.oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = var.oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]
}

resource "aws_iam_role" "cluster_autoscaler" {
  name = "cluster-autoscaling-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_full" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "autoscaling_full" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}

#####################################################
# Platform Admin Role
#####################################################
resource "aws_iam_role" "platform_admin" {
  count = var.create_platform_admin_role ? 1 : 0

  name = var.platform_admin_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for principal_arn in var.platform_admin_principal_arns : {
        Effect = "Allow"
        Principal = {
          AWS = principal_arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "platform_admin" {
  count = var.create_platform_admin_role ? 1 : 0

  role       = aws_iam_role.platform_admin[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}