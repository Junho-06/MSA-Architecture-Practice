terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }
    helm = {
      source  = "hashicorp/helm"
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


provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}