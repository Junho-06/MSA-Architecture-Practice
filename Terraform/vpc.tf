locals {
  name_prefix     = "msa"
  azs             = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b"]
  public_subnets  = ["10.0.0.0/24", "10.0.16.0/24"]
  private_subnets = ["10.0.32.0/24", "10.0.64.0/24"]
  vpc_cidr        = "10.0.0.0/16"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = local.vpc_cidr
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  name_prefix     = local.name_prefix

  private_subnet_tags = {
  # 이부분 에러남 이게 되야 ingress 생성 될듯
    "kubernetes.io/role/internal-elb" = "1"
  }

  public_subnet_tags = {
  # 이부분 에러남 이게 되야 ingress 생성 될듯
    "kubernetes.io/role/elb" = "1"
  }
}