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


locals {
  helm-repository = "https://junho-06.github.io/MSA-Architecture-Practice/helm-charts"

  argocd-name     = "argo-cd"
  argocd-version  = "5.45.0"
}

resource "helm_release" "argo-cd" {
  name       = local.argocd-name
  repository = local.helm-repository
  chart      = local.argocd-name
  version    = local.argocd-version
}