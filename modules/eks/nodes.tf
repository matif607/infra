resource "aws_eks_node_group" "general" {
  cluster_name = aws_eks_cluster.this.name
  node_group_name = "general-nodes"
  node_role_arn = aws_iam_role.nodes.arn
  # subnet_ids = split(",", data.aws_ssm_parameter.private_subnets.value)
  subnet_ids = var.private_subnet_ids

  capacity_type = "ON_DEMAND"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size = 4
    min_size = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.registry_policy
  ]
}