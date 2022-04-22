terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.13.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.7.2"
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

resource "google_kms_key_ring" "google_kms_key_ring" {
  name     = "${var.name}_${random_id.random_id.hex}"
  location = var.location
}

resource "google_kms_crypto_key" "google_kms_crypto_key" {
  name            = "${var.name}_${random_id.random_id.hex}"
  key_ring        = google_kms_key_ring.google_kms_key_ring.id
  rotation_period = "7776000s"
}

resource "time_sleep" "time_sleep" {
  depends_on = [google_kms_crypto_key.google_kms_crypto_key]

  create_duration = "30s"
}

data "google_storage_project_service_account" "google_storage_project_service_account" {
}

resource "google_kms_crypto_key_iam_binding" "google_kms_crypto_key_iam_binding" {
  depends_on = [time_sleep.time_sleep]

  crypto_key_id = google_kms_crypto_key.google_kms_crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.google_storage_project_service_account.email_address}"]
}

resource "google_storage_bucket" "google_storage_bucket" {
  depends_on = [google_kms_crypto_key_iam_binding.google_kms_crypto_key_iam_binding]

  name          = "${var.name}_${random_id.random_id.hex}"
  location      = var.location
  force_destroy = var.force_destroy

  storage_class            = var.storage_class
  default_event_based_hold = var.default_event_based_hold

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  logging {
    log_bucket = "${var.name}_logging_${random_id.random_id.hex}"
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.google_kms_crypto_key.id
  }
}
