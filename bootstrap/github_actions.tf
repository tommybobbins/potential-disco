locals {
  roles = [
    "roles/resourcemanager.projectIamAdmin", # GitHub Actions identity
    "roles/editor",                          # allow to manage all resources
    "roles/container.admin",                 # GitHub Actions needs to be able to manage GKE 
    "roles/secretmanager.secretAccessor",    # GitHub Actions needs to be able to read secrets
  ]
  github_repository_name = var.github_repo # e.g. yourname/yourrepo
}

resource "google_service_account" "github_actions" {
  project      = var.project
  account_id   = "github-actions"
  display_name = "github actions"
  description  = "link to Workload Identity Pool used by GitHub Actions"
}

# Allow to access all resources
resource "google_project_iam_member" "roles" {
  project = var.project
  for_each = {
    for role in local.roles : role => role
  }
  role   = each.value
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_iam_workload_identity_pool" "github" {
  #  provider                  = google-beta
  project                   = var.project
  workload_identity_pool_id = "github"
  display_name              = "github"
  description               = "GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  #  provider                           = google-beta
  project                            = var.project
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  description                        = "OIDC identity pool provider for execute GitHub Actions"
  # See. https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.owner"      = "assertion.repository_owner"
    "attribute.refs"       = "assertion.ref"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_condition = "assertion.repository_owner=='tommybobbins'"
}

resource "google_service_account_iam_member" "github_actions" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${local.github_repository_name}"
}

output "service_account_github_actions_email" {
  description = "Service Account used by GitHub Actions"
  value       = google_service_account.github_actions.email
}

output "google_iam_workload_identity_pool_provider_github_name" {
  description = "Workload Identity Pood Provider ID"
  value       = google_iam_workload_identity_pool_provider.github.name
}
