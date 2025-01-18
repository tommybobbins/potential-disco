locals {
  services = toset([
    "appengine.googleapis.com",
    "appenginereporting.googleapis.com",
    "autoscaling.googleapis.com",
    "bigquerystorage.googleapis.com",
    "certificatemanager.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudtrace.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "datastore.googleapis.com",
    "deploymentmanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "secretmanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "sts.googleapis.com"

    # You can add more apis to enable in the project
  ])
}

resource "google_project_service" "service" {
  for_each = local.services
  project  = var.project
  service  = each.value
}
