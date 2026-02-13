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
  user_namespaces = var.user_namespaces
  eks_version = "1.31"
}

# This fetches the authentication token for the cluster we just planned
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Now we create the "Jenkins" namespace so Bob's permissions have a target
resource "kubernetes_namespace_v1" "user_space" {
  for_each = toset(var.user_namespaces)
  metadata {
    name = each.value
  }
}