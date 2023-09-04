data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.msa_eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.msa_eks_cluster.cluster_id
}