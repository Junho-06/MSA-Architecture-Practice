locals {
  helm-repository = "https://junho-06.github.io/MSA-Architecture-Practice/helm-charts"

  argocd-name      = "argo-cd"
  argocd-version   = "5.45.0"
  argocd-namespace = "argocd"
}

resource "helm_release" "argo-cd" {
  name       = local.argocd-name
  repository = local.helm-repository
  chart      = local.argocd-name
  version    = local.argocd-version

  namespace        = local.argocd-namespace
  create_namespace = true
}