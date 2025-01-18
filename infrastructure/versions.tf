terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.68.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
  required_version = "> 0.14"

  backend "gcs" {
    bucket = "skilled-circle-448210-terraform" # need to update with the bucket name
    prefix = "infrastructure-state"
  }
}
