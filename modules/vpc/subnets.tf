resource "aws_subnet" "public" {
  count = min(length(var.public_subnets), length(data.aws_availability_zones.AZs.names))
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.AZs.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private" {
  count = min(length(var.private_subnets), length(data.aws_availability_zones.AZs.names))
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.AZs.names[count.index]
  tags = {
    Name = "${var.vpc_name}-private-${count.index +  1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}