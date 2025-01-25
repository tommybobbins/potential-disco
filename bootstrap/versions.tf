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
    # Change this to your bucket
    bucket = "wibble-flibble-123456-terraform" # need to update with the bucket name
    prefix = "state"
  }
}
