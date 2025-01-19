variable "gh_pat_token" {
  default = {
    "url"          = "REPLACE ME!"
    "gh_pat_token" = "REPLACE ME!"
  }
  type = map(string)
}

resource "google_secret_manager_secret" "gh_pat_token" {
  secret_id = "gh-pat-token"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "gh_pat_token" {
  secret      = google_secret_manager_secret.gh_pat_token.id
  secret_data = jsonencode(var.gh_pat_token)
  lifecycle {
    ignore_changes = [secret_data, enabled]
  }
}
