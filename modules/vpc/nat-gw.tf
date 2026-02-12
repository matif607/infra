resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }
  depends_on = [ aws_internet_gateway.this ]
}