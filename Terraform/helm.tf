locals {
  helm-repository = "https://junho-06.github.io/MSA-Architecture-Practice"

  argocd-name      = "argo-cd"
  argocd-version   = "5.45.0"
  argocd-namespace = "argocd"

  application-name      = "application"
  application-version   = "0.1.0"
  application-namespace = "default"
}

resource "helm_release" "argo-cd" {
  name       = local.argocd-name
  repository = local.helm-repository
  chart      = local.argocd-name
  version    = local.argocd-version

  namespace        = local.argocd-namespace
  create_namespace = true
}

resource "helm_release" "application" {
  name       = local.application-name
  repository = local.helm-repository
  chart      = local.application-name
  version    = local.application-version

  namespace        = local.application-namespace
  #create_namespace = true
}