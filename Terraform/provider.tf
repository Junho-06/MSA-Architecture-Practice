terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.15.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.11.0"
    }
  }
  cloud {
    hostname     = "app.terraform.io"
    organization = "solo-study"
    workspaces {
      name = "msa-practice"
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

provider "aws" {
  region = var.region
}