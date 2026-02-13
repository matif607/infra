resource "aws_eks_cluster" "this" {
  name = "${var.environment}-${var.cluster_name}"
  role_arn = aws_iam_role.cluster.arn
  version = var.eks_version
  
  vpc_config {
    vpc_id = var.vpc_id
    subnet_ids = var.private_subnet_ids
    # vpc_id = data.aws_ssm_parameter.vpc_id.value
    # subnet_ids = split(",", data.aws_ssm_parameter.private_subnets.value)
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [ aws_iam_role_policy_attachment.cluster_policy ]
}