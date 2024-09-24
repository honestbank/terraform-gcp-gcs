terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.22"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}

resource "random_id" "random_id" {
  byte_length = 4
}

module "test_bucket" {
  source = "../../modules/gcp_gcs_bucket"

  location   = "asia-southeast2"
  name       = "test-bucket"
  project_id = "storage-44a30d2d"

  force_destroy = true
}

module "test_bucket_with_retention" {
  source = "../../modules/gcp_gcs_bucket"

  location   = "asia-southeast2"
  name       = "test-bucket-with-retention"
  project_id = "storage-44a30d2d"

  object_versioning_enabled = false
  retention_lock_enabled    = true

  soft_delete_retention_duration_seconds = 0

  force_destroy = true
}
