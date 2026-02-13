output "user_arns" {
  value = { for u in aws_iam_user.devs : u.name => u.arn }
}

output "developer_role_arn" {
  value = aws_iam_role.eks_developer_role.arn
}