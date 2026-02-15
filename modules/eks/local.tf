locals {
  # This map translates your role names into AWS Policy ARNs
  role_policy_mapping = {
    "superadmin" = "arn:aws:iam::aws:eks:aws-managed-access-policy/AmazonEKSClusterAdminPolicy"
    "admin"      = "arn:aws:iam::aws:eks:aws-managed-access-policy/AmazonEKSAdminPolicy"
    "developer"  = "arn:aws:iam::aws:eks:aws-managed-access-policy/AmazonEKSEditPolicy"
  }
}