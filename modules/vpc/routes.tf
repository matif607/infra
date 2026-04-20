resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table" "private" {
  for_each = var.nat_gateway_azs
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }
  tags = {
    Name = "${var.vpc_name}-private-rt-${each.key}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id =try(
    aws_route_table.private[each.key].id,
    aws_route_table.private[local.primary_nat_az].id
  )
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count = var.enable_endpoints ? 1 : 0
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.public.id
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  for_each = var.enable_endpoints ? aws_route_table.private : {}
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = each.value.id
}