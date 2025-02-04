resource "kubectl_manifest" "argo_application" {
  for_each = toset(var.argocd_applications)
  yaml_body = templatefile("../helm/argo_applications/application.yaml",
    {
      NAME       = "${each.value}"
      GH_URL     = "https://github.com/tommybobbins/potential-disco"
      ENV        = "main"
      PATH       = "helm/${each.value}"
      NAMESPACE  = "scrapers"
      PROJECT_ID = var.project
      REGION     = var.region
  })
  depends_on = [
    helm_release.argocd,
  ]
}
