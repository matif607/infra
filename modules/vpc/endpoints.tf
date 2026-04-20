resource "aws_vpc_endpoint" "s3" {
  count = var.enable_endpoints ? 1 : 0
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${data.aws_region.current.id}.s3"

  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "${var.vpc_name}-s3-gw-endpoint"
  }
}

resource "aws_security_group" "vpc_endpoints" {
  count       = var.enable_endpoints ? 1 : 0
  name        = "${var.vpc_name}-vpc-endpoints"
  description = "Allow inbound traffic from VPC to interface"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = var.enable_endpoints ? toset([
    "ecr.api",
    "ecr.dkr"
  ]) : []

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.${each.key}"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  subnet_ids          = values(aws_subnet.private[*].id)
  private_dns_enabled = true

  tags = {
    Name = "${var.vpc_name}-${each.key}-endpoint"
  }
}