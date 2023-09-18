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
  argocd-version   = "0.1.1"
  argocd-namespace = "argocd"

  application-name      = "application"
  application-version   = "0.1.1"

  istio-name      = "istio"
  istio-version   = "0.1.0"
  istio-namespace = "istio-system"
}

module "argo-cd" {
  source        = "./modules/helm"
  name          = local.argocd-name
  namespace     = local.argocd-namespace
  repository    = local.helm-repository
  chart         = local.argocd-name
  chart_version = local.argocd-version
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

module "istio" {
  source        = "./modules/helm"
  name          = local.istio-name
  namespace     = local.istio-namespace
  repository    = local.helm-repository
  chart         = local.istio-name
  chart_version = local.istio-version
}