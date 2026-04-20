variable "vpc_cidr" { type = string }

variable "vpc_name" { type = string }

variable "environment" { type = string }

variable "public_subnets_by_az" {
  type        = map(string)
  description = "Public subnets by availability zone"
}

variable "private_subnets_by_az" {
  type        = map(string)
  description = "Private subnets by availability zone"
}

variable "nat_gateway_azs" {
  type        = set(string)
  description = "Set of AZ names where a NAT gateway should be created"
  default = []
  validation {
    condition = alltrue([
      for az in var.nat_gateway_azs:
      contains(keys(var.public_subnets_by_az), az)
    ])
    error_message = "All nat_gateway_azs must be AZs that exist in public_subnets_by_az (NAT must be placed in a public subnet AZ)."
  }
}
variable "cluster_name" {
  type    = string
  default = null
}

variable "enable_endpoints" {
    type        = bool
    description = "whether to create VPC endpoints"
    default     = false
}