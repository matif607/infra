module "dev_vpc" {
  source      = "../../modules/vpc/"
  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  vpc_name    = "${var.project}-${var.environment}-vpc"

  public_subnets_by_az  = var.public_subnets_by_az
  private_subnets_by_az = var.private_subnets_by_az
  nat_gateway_azs       = var.nat_gateway_azs

  cluster_name     = var.cluster_name
  enable_endpoints = var.enable_endpoints
}