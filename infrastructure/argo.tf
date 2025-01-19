resource "helm_release" "argocd" {
  count            = var.argocd_enabled ? 1 : 0
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = var.argo_version
  values           = [file("../helm/argo/argocd-values.yaml")]
  depends_on = [
    google_container_cluster.primary
  ]
}

resource "kubectl_manifest" "argocd_gh_credentials" {
  yaml_body = templatefile("../helm/argo/repo.yaml",
    {
      URL   = jsondecode(data.google_secret_manager_secret_version.gh_pat_token.secret_data)["url"],
      TOKEN = jsondecode(data.google_secret_manager_secret_version.gh_pat_token.secret_data)["gh_pat_token"]
  })
  depends_on = [
    helm_release.argocd
  ]
}

