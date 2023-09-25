provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = module.eks.cluster_ca_certificate
    token                  = module.eks.cluster_auth_token
  }
}

locals {
  helm-repository = "https://junho-06.github.io/MSA-Architecture-Practice"

  argocd-name      = "argo-cd"
  argocd-version   = "0.1.6"
  argocd-namespace = "argocd"

  application-name      = "application"
  application-version   = "0.1.1"

  aws-load-balancer-controller-name      = "aws-load-balancer-controller"
  aws-load-balancer-controller-version   = "1.6.4"
  aws-load-balancer-controller-namespace = "kube-system"
}

module "argo-cd" {
  source        = "./modules/helm"
  name          = local.argocd-name
  namespace     = local.argocd-namespace
  repository    = local.helm-repository
  chart         = local.argocd-name
  chart_version = local.argocd-version

  create_namespace = true
}

module "application" {
  source        = "./modules/helm"
  name          = local.application-name
  namespace     = local.argocd-namespace
  repository    = local.helm-repository
  chart         = local.application-name
  chart_version = local.application-version

  create_namespace = true
}

module "aws-load-balancer-controller" {
  source        = "./modules/helm"
  name          = local.aws-load-balancer-controller-name
  namespace     = local.aws-load-balancer-controller-namespace
  repository    = local.helm-repository
  chart         = local.aws-load-balancer-controller-name
  chart_version = local.aws-load-balancer-controller-version

  create_namespace = true
}