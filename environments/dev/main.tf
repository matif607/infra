module "dev_vpc" {
  source = "../../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "dev-central-vpc"
  cluster_name = "opcompdev"
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
  admin_arn = local.current_user_arn
  cluster_name = "opcompdev"
  vpc_id = module.dev_vpc.vpc_id # this can be read directly from ssm if its there
  private_subnet_ids = module.dev_vpc.private_subnets # this can be read directly from ssm if its there
  # This list now contains fully qualified, dynamic ARNs
  permanent_admins = local.all_permanent_admins
  developer_names = var.developer_names
  user_arns = {
    for name, role in var.developer_names :
    name => "arn:aws:iam::${local.account_id}:user/${name}"
  }
  developer_role_arn = module.iam.developer_role_arn
  user_namespaces = var.user_namespaces
  eks_version = "1.31"
}