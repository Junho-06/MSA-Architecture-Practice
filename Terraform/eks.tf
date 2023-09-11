resource "aws_iam_role" "cluster_role" {
  name = "msa-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "attach_AmazonEKSClusterPolicy_to_Role" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}
resource "aws_iam_role_policy_attachment" "attach_AmazonEKSVPCResourceController_to_Role" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.name
}


resource "aws_eks_cluster" "msa_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn

  enabled_cluster_log_types = ["api", "audit", "controllerManager"]

  vpc_config {
    subnet_ids = [
      aws_subnet.msa_private_subnet_a.id,
      aws_subnet.msa_private_subnet_b.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.attach_AmazonEKSClusterPolicy_to_Role,
    aws_iam_role_policy_attachment.attach_AmazonEKSVPCResourceController_to_Role
  ]

  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = data.aws_caller_identity.current.arn
      username = element(split("/", data.aws_caller_identity.current.arn), 1)
      groups   = ["system:masters"]
    }
  ]

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}

locals {
  cluster_version = "1.27"
  node_type       = "t3.small"
  capacity_type   = "ON_DEMAND"
}

module "eksv2" {
  source                 = "./modules/eks"

  name_prefix     = local.name_prefix
  cluster_version = local.cluster_version
  instance_type   = local.node_type
  capacity_type   = local.capacity_type

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.private_subnet_ids

  nodegroup_min_size     = 1
  nodegroup_max_size     = 2
  nodegroup_desired_size = 1
}