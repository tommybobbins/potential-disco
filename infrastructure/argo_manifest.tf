#resource "kubectl_manifest" "argo_application" {
#  for_each = toset(keys(var.argocd_applications))
#  yaml_body = templatefile("../helm/argo_applications/application.yaml",
#    {
#      NAME       = "${each.key}"
#      GH_URL     = "https://github.com/tommybobbins/potential-disco.git"
#      ENV        = "main"
#      PATH       = "helm/${each.key}"
#      NAMESPACE  = lookup(var.argocd_applications,each.key)
#      PROJECT_ID = var.project
#      REGION     = var.region
#  })
#  depends_on = [
#    helm_release.argocd,
#  ]
#}


resource "kubectl_manifest" "argo_application" {
  for_each = toset(keys(var.argocd_applications))
  yaml_body = templatefile("${lookup(var.templatefile,each.key)}",
    {
      NAME       = "${each.key}"
      GH_URL     = "https://github.com/tommybobbins/potential-disco.git"
      ENV        = "main"
      PATH       = "helm/${each.key}"
      NAMESPACE  = lookup(var.argocd_applications,each.key)
      PROJECT_ID = var.project
      REGION     = var.region
  })
  depends_on = [
    helm_release.argocd,
  ]
}
