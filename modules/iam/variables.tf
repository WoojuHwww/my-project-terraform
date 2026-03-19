variable "oidc_issuer_url" {
  description = "OIDC issuer URL from EKS cluster"
  type        = string
}

variable "create_platform_admin_role" {
  description = "Whether to create a platform admin IAM role"
  type        = bool
  default     = true
}

variable "platform_admin_role_name" {
  description = "Name of the platform admin IAM role"
  type        = string
  default     = "PlatformAdminRole"
}

variable "platform_admin_principal_arns" {
  description = "IAM principal ARNs allowed to assume the platform admin role"
  type        = list(string)
  default     = []
}