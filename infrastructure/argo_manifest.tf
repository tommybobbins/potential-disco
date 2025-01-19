#resource "kubectl_manifest" "argo_application" {
#  for_each = toset(var.argocd_applications)
#  yaml_body = templatefile("../helm/argo_applications/application.yaml",
#    {
#      NAME            = "${each.value}"
#      GH_URL          = "foobar"
#      ENV             = "main"
#      PATH            = each.value
#      NAMESPACE       = "scrapers"
#  })
#  depends_on = [
#    helm_release.argocd,
#  ]
#}
