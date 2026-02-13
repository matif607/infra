module "dev_vpc" {
  source = "../../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "dev-central-vpc"
  environment = "dev"
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets = ["10.0.2.0/24", "10.0.3.0/24"]
}

module "iam" {
  source          = "../../modules/iam"
  developer_names = var.developer_names
}

module "eks" {
  source = "../../modules/eks"
  environment = "dev"
  cluster_name = "opcompdev"
  vpc_id = module.dev_vpc.vpc_id # this can be read directly from ssm if its there
  private_subnet_ids = module.dev_vpc.private_subnets # this can be read directly from ssm if its there
  developer_names = var.developer_names
  user_arns = module.iam.user_arns
  developer_role_arn = module.iam.developer_role_arn
  eks_version = "1.31"
}