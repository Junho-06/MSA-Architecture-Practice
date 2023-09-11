data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.msa_eks_cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.msa_eks_cluster.name
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_availability_zones" "available" {}