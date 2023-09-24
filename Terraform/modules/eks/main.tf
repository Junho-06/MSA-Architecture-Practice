locals {
  cluster_name     = "${var.name_prefix}-cluster"
  cluster_version  = var.cluster_version
  region           = "ap-northeast-2"
  vpc_id           = var.vpc_id
  private_subnets  = var.private_subnets
  current_username = element(split("/", data.aws_caller_identity.current.arn), 1)
  instance_type    = var.instance_type
  capacity_type    = var.capacity_type
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnets

  enable_irsa = true

  cluster_enabled_log_types = []
  create_cloudwatch_log_group = false

  eks_managed_node_group_defaults = {
    instance_types = [local.instance_type]
    capacity_type  = local.capacity_type
  }
  eks_managed_node_groups = {
    initial = {
      instance_types         = [local.instance_type]
      create_security_group  = false
      create_launch_template = true
      launch_template_name   = "msa-default-lt"

      min_size     = var.nodegroup_min_size
      max_size     = var.nodegroup_max_size
      desired_size = var.nodegroup_desired_size

      iam_role_additional_policies = {
        ssm_managed_instance_core = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_ntp_ipv4_cidr_block = ["169.254.169.123/32"]
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = data.aws_caller_identity.current.arn
      username = local.current_username
      groups   = ["system:masters"]
    }
  ]

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks.cluster_name]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_availability_zones" "available" {}