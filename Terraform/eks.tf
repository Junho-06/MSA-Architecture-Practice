locals {
  cluster_version = "1.27"
  node_type       = "t3.small"
  capacity_type   = "ON_DEMAND"
}

module "eks" {
  source                 = "./modules/eks"

  name_prefix     = local.name_prefix
  cluster_version = local.cluster_version
  instance_type   = local.node_type
  capacity_type   = local.capacity_type

  vpc_id           = aws_vpc.msa_vpc.id
  private_subnets  = [aws_subnet.msa_private_subnet_a.id, aws_subnet.msa_private_subnet_b.id]

  nodegroup_min_size     = 1
  nodegroup_max_size     = 2
  nodegroup_desired_size = 1
}