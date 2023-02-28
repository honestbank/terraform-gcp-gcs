terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.51.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.2"
    }
  }
}

resource "random_id" "random_id" {
  byte_length = 4
}

module "test_bucket" {
  source = "../../modules/gcp_gcs_bucket"

  location = "asia-southeast2"
  name     = "test-bucket"

  force_destroy = true
}
