variable "google_project" {
  type        = string
  description = "Project that dataset will be created"
}

variable "google_credentials" {
  type        = string
  description = "JSON GCP IAM credentials that have GCP Owner and BigQuery Admin Role granted"
}

provider "google" {
  credentials = var.google_credentials
  project     = var.google_project
}
