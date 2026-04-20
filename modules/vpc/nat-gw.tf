resource "aws_eip" "nat" {
  for_each = var.nat_gateway_azs
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-nat-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each = var.nat_gateway_azs
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags = {
    Name = "${var.vpc_name}-nat-gw-${each.key}"
  }
  depends_on = [aws_internet_gateway.this]
}