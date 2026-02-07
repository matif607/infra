resource "vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_ssm_parameter" "vpc_id" {
  name = "/network/${var.environment}/vpc_id"
  type = "String"
  value = aws_vpc.this.id
}