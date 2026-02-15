resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.this.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "${var.vpc_name}-s3-gw-endpoint"
  }
}

resource "aws_security_group" "vpc_endpoints" {
  name = "${var.vpc_name}-vpc-endpoints"
  description = "Allow inbound traffic from VPC to interface"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
}

resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = toset([
    "ecr.api",
    "ecr.dkr",
    "ssm",
    "ssmmessages",
    "sts",
    "elasticloadbalancing",
    "logs",
    "autoscaling"
  ])

  vpc_id = aws_vpc.this.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoints.id]
  subnet_ids = aws_subnet.private[*].id
  private_dns_enabled = true

  tags = {
    Name = "${var.vpc_name}-${each.key}-endpoint"
  }
}