variable "project" {
  type        = string
  description = "Project name, e.g. 'opcomp'"
}

variable "environment" {
  type        = string
  description = "Environment name, e.g. 'dev'"
}

variable "region" {
  type        = string
  description = "Region name, e.g. 'us-east-1'"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block, e.g. '10.0.0.0/16'"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name, e.g. 'opcomp-dev'"
}

variable "enable_endpoints" {
  type        = bool
  description = "whether to create VPC endpoints"
  default     = false
}

variable "public_subnets_by_az" {
  type        = map(string)
  description = "Map of AZ => public subnet CIDR"
}
variable "private_subnets_by_az" {
  type        = map(string)
  description = "Map of AZ => private subnet CIDR"
}
variable "nat_gateway_azs" {
  type        = set(string)
  description = "Set of AZs where NAT gateways should exist"
  default     = []
}