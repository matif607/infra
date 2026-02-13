resource "aws_iam_user" "devs" {
  for_each = var.developer_names
  name = each.key
}

resource "aws_iam_role" "eks_developer_role" {
  name = "EKS_Developer-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                AWS = [for u in aws_iam_user.devs : u.arn]
            }
        }
    ]
  })
}