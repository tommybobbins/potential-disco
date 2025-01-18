resource "google_artifact_registry_repository" "repo" {
  for_each      = var.container_artifact_registry
  location      = var.region
  repository_id = each.key
  description   = "${each.key} Respository"
  format        = "DOCKER"
}
