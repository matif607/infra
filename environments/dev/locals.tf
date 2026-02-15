# data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  
  # 1. The identity currently running Terraform (Atif or CI/CD)
  current_user_arn = data.aws_caller_identity.current.arn

  # 2. Build User ARNs from the list in terraform.tfvars
  admin_user_arns = [
    for name in var.permanent_admin_users : 
    "arn:aws:iam::${local.account_id}:user/${name}"
  ]

  # 3. Build Role ARNs from the list in terraform.tfvars
  admin_role_arns = [
    for role in var.permanent_admin_roles : 
    "arn:aws:iam::${local.account_id}:role/${role}"
  ]

  # 4. MASTER LIST: Combine everything into one single list
  # We add the current_user_arn here so the "creator" is always included
  all_permanent_admins = distinct(concat(
    [local.current_user_arn], 
    local.admin_user_arns, 
    local.admin_role_arns
  ))
}