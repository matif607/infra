variable "environment" {
  type = string
  description = "The environment name (eg: dev)"
}

variable "cluster_name" {
  type = string
  description = "name of the eks cluster"
}

variable "eks_version" {
  type = string
  default = "1.31"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID from the VPC module"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of private subnets from the VPC module"
}

variable "developer_role_arn" {
  type = string
}

variable "developer_names" {
  type = map(string)
}

variable "user_arns" {
  type = map(string)
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

variable "user_namespaces" {
  type = list(string)
  default = [ "jenkins" ]
}