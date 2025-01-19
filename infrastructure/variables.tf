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

variable "gke_cluster_ipv4_block" {
  description = "Kubernetes IPv4 CIDR block"
  default     = "10.96.0.0/14"
}

variable "gke_services_ipv4_block" {
  description = "Kubernetes Services IPv4 CIDR block"
  default     = "10.192.0.0/16"
}

variable "vpc_ipv4_block" {
  description = "VPC IPv4 CIDR block"
  default     = "10.23.23.0/24"
}

variable "container_artifact_registry" {
  description = "List of container registries"
  type        = list(any)
  default = [
    "powerstation-prom-exporter",
  ]
}

variable "argocd_applications" {
  description = "contact applications to be deployed via Argo"
  default = [
    "powerstation-prom-exporter",
  ]
}
