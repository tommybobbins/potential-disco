resource "kubectl_manifest" "argo_application" {
  for_each = toset(var.argocd_applications)
  yaml_body = templatefile("../helm/argo_applications/application.yaml",
    {
      NAME            = "${each.value}"
      GH_URL          = "https://github.com/tommybobbins/potential-disco"
      ENV             = "main"
      PATH            = "helm/argo_applications/${each.value}"
      NAMESPACE       = "scrapers"
  })
  depends_on = [
    helm_release.argocd,
  ]
}
