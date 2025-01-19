data "google_secret_manager_secret_version" "gh_pat_token" {
  secret = "gh-pat-token"
}
