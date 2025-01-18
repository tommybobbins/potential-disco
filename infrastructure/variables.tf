// Configure the Google Cloud provider

variable "region" {
  description = "Google Cloud region"
  default     = "europe-west2"
}

variable "project" {
  description = "Google Cloud Project Name"
  default     = "my-project-name"
}

variable "env" {
  description = "Project environment"
  default     = "dev"
}

variable "cost_centre" {
  description = "Project Cost Centre"
  default     = "costly"
}

variable "thisproject" {
  description = "Project Name"
  default     = "projectly"
}

variable "alias" {
  description = "Project Alias"
  default     = "bobbins"
}


locals {
  project_labels = {
    "env"         = var.env
    "alias"       = var.alias
    "cost_centre" = var.cost_centre
    "project"     = var.thisproject
    "gcp_project" = var.project
  }
}

variable "project_lifecycle" {
  description = "Project lifecycle (future production environment can be in development)"
  default     = "live"
}

variable "argo_version" {
  description = "Helm Chart version for ArgoCD"
  default     = "7.7.16"
}

variable "argocd_enabled" {
  description = "ArgoCD enabled"
  type        = bool
  default     = false
}

