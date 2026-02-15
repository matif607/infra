resource "aws_eks_access_entry" "permanent_admins" {
  for_each      = toset(var.permanent_admins)
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "permanent_admin_policy" {
  for_each      = toset(var.permanent_admins)
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:iam::aws:eks:aws-managed-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = each.value

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "user_list" {
  for_each = var.developer_names
  cluster_name = aws_eks_cluster.this.name
  principal_arn = var.user_arns[each.key]
  type = "STANDARD"
  kubernetes_groups = each.value == "developer" ? ["developers"] : []
}

resource "aws_eks_access_policy_association" "dynamic_policies" {
  for_each = var.developer_names
  cluster_name = aws_eks_cluster.this.name
  policy_arn = local.role_policy_mapping[each.value]
  principal_arn = var.user_arns[each.key]
  access_scope {
    type = each.value == "developer" ? "namespace" : "cluster"
    namespaces = each.value == "developer" ? var.user_namespaces : null
  }
  depends_on = [ aws_eks_access_entry.user_list]
}

resource "aws_eks_access_policy_association" "cluster_admin" {
  cluster_name = aws_eks_cluster.this.name
  policy_arn = "arn:aws:iam::aws:eks:aws-managed-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.admin_arn
  access_scope {
    type = "cluster"
  }
}