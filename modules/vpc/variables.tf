variable "vpc_cidr" { type = string }
variable "vpc_name" { type = string }
variable "environment" { type = string }
variable "public_subnets" {
  type = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable "private_subnets" {
  type = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "cluster_name" {
  type = string
}