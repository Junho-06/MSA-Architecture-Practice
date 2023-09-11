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
  argocd-version   = "0.1.0"
  argocd-namespace = "argocd"

  application-name      = "application"
  application-version   = "0.1.0"
  application-namespace = "default"
}

resource "helm_release" "argo-cd" {
  source           = "./modules/helm"
  name             = local.argocd-name
  repository       = local.helm-repository
  chart            = local.argocd-name
  version          = local.argocd-version
  namespace        = local.argocd-namespace
  create_namespace = true
}

resource "helm_release" "application" {
  source     = "./modules/helm"
  name       = local.application-name
  repository = local.helm-repository
  chart      = local.application-name
  version    = local.application-version
  namespace  = local.application-namespace
  #create_namespace = true
}