resource "aws_ssm_parameter" "vpc_id" {
  name = "/network/${var.environment}/vpc_id"
  type = "String"
  value = aws_vpc.this.id
  depends_on = [
    aws_nat_gateway.this,
    aws_route_table_association.public,
    aws_route_table_association.private
   ]
}

resource "aws_ssm_parameter" "private_subnets" {
  name = "/network/${var.environment}/private_subnets"
  type = "StringList"
  value = join(",", aws_subnet.private[*].id)
  depends_on = [ aws_route_table_association.private]
}

resource "aws_ssm_parameter" "public_subnets" {
  name = "/network/${var.environment}/public_subnets"
  type = "StringList"
  value = join(",", aws_subnet.public[*].id)
  depends_on = [ aws_route_table_association.public]
}