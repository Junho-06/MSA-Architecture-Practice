module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  nat_gateway_tags = {
    Name = "${var.name_prefix}-nat"
  }

  igw_tags = {
    Name = "${var.name_prefix}-igw"
  }
  map_public_ip_on_launch = true
}