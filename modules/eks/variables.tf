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

variable "user_namespaces" {
  type = list(string)
  default = [ "jenkins" ]
}

variable "admin_arn" {
  type        = string
  description = "The ARN of the primary cluster administrator"
}

variable "permanent_admins" {
  type = list(string)
  default = []
}