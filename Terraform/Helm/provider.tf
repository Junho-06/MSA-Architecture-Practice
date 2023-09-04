terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.msa_eks_cluster.endpoint
    cluster_ca_certificate = aws_eks_cluster.msa_eks_cluster.cluster_ca_certificate
    token                  = aws_eks_cluster.msa_eks_cluster.cluster_auth_token
  }
}