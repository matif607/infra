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