resource "aws_subnet" "public" {
  for_each = var.public_subnets_by_az
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "${var.vpc_name}-public-${each.key}"
      "kubernetes.io/role/elb" = "1"
    },
    var.cluster_name == null ? {} : {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
  )
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets_by_az
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = merge(
    {
      Name = "${var.vpc_name}-private-${each.key}"
      "kubernetes.io/role/internal-elb" = "1"
    },
    var.cluster_name == null ? {} : {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
  )
}