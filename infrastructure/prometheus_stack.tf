resource "kubectl_manifest" "argo_prometheus_stack" {
  yaml_body = templatefile("../helm/argo_applications/prometheus/application.yaml",
    {
      HELM_VERSION                     = var.prometheus_stack_version
  })
  depends_on = [
    helm_release.argocd,
  ]
}
