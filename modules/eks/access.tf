resource "aws_eks_access_entry" "dev_access" {
  cluster_name = aws_eks_cluster.this.name
  principal_arn = var.developer_role_arn
  kubernetes_groups = ["developers"]
}

resource "aws_eks_access_policy_association" "super_admin" {
  for_each = { for name, role in var.developer_names : name => name if role == "superadmin" }
  
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.user_arns[each.key] # Uses the ARN of 'charlie'

  access_scope { type = "cluster" }
}

# 2. Admins
resource "aws_eks_access_policy_association" "admin" {
  for_each = { for name, role in var.developer_names : name => name if role == "admin" }
  
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = var.user_arns[each.key] # Uses the ARN of 'alice'

  access_scope { type = "cluster" }
}

# 3. Developers (using the shared Role ARN)
resource "aws_eks_access_policy_association" "dev_policy" {
  for_each = { for name, role in var.developer_names : name => name if role == "developer" }
  
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
  principal_arn = var.developer_role_arn # Everyone with 'developer' role uses the same Role ARN

  access_scope {
    type       = "namespace"
    namespaces = ["jenkins"]
  }
}