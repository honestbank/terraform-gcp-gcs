terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.51.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.2"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.2"
    }
  }
}

resource "random_id" "random_id" {
  byte_length = 4
}

resource "google_kms_key_ring" "google_kms_key_ring" {
  #checkov:skip=CKV_GCP_82: Need to skip this because it wants to prevent us from destroying the KMS but terratest need to destroy it
  name     = "${var.name}_${random_id.random_id.hex}"
  project  = var.project_id
  location = var.location
}

resource "google_kms_crypto_key" "google_kms_crypto_key" {
  #checkov:skip=CKV_GCP_82: Need to skip this because it wants to prevent us from destroying the KMS but terratest need to destroy it
  #checkov:skip=CKV2_GCP_6:Keys are used in modules
  name            = "${var.name}_${random_id.random_id.hex}"
  key_ring        = google_kms_key_ring.google_kms_key_ring.id
  rotation_period = "7776000s" # 90 days
}

resource "time_sleep" "time_sleep" {
  depends_on = [google_kms_crypto_key.google_kms_crypto_key]

  create_duration = "30s"
}

data "google_storage_project_service_account" "google_storage_project_service_account" {
  project = var.project_id
}

resource "google_kms_crypto_key_iam_binding" "google_kms_crypto_key_iam_binding" {
  depends_on = [time_sleep.time_sleep]

  crypto_key_id = google_kms_crypto_key.google_kms_crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.google_storage_project_service_account.email_address}"]
}

resource "google_storage_bucket" "google_storage_bucket_logging" {
  #checkov:skip=CKV_GCP_62: logging bucket doesn't need a log
  #checkov:skip=CKV_GCP_78:: logging bucket doesn't need a version

  depends_on = [google_kms_crypto_key_iam_binding.google_kms_crypto_key_iam_binding]
  name       = "${var.name}_logging_${random_id.random_id.hex}"
  project    = var.project_id

  location                    = var.location
  force_destroy               = var.force_destroy
  storage_class               = "ARCHIVE"
  uniform_bucket_level_access = true

  public_access_prevention = "enforced"

  encryption {
    default_kms_key_name = google_kms_crypto_key.google_kms_crypto_key.id
  }
}

resource "google_storage_bucket" "google_storage_bucket" {
  name          = "${var.name}_${random_id.random_id.hex}"
  location      = var.location
  force_destroy = var.force_destroy
  project       = var.project_id

  storage_class            = var.storage_class
  default_event_based_hold = var.default_event_based_hold

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }

  logging {
    log_bucket = google_storage_bucket.google_storage_bucket_logging.name
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.google_kms_crypto_key.id
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                        = lookup(lifecycle_rule.value.condition, "age", null)
        created_before             = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state                 = lookup(lifecycle_rule.value.condition, "with_state", lookup(lifecycle_rule.value.condition, "is_live", false) ? "LIVE" : null)
        matches_storage_class      = contains(keys(lifecycle_rule.value.condition), "matches_storage_class") ? split(",", lifecycle_rule.value.condition["matches_storage_class"]) : null
        matches_prefix             = contains(keys(lifecycle_rule.value.condition), "matches_prefix") ? split(",", lifecycle_rule.value.condition["matches_prefix"]) : null
        matches_suffix             = contains(keys(lifecycle_rule.value.condition), "matches_suffix") ? split(",", lifecycle_rule.value.condition["matches_suffix"]) : null
        num_newer_versions         = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        custom_time_before         = lookup(lifecycle_rule.value.condition, "custom_time_before", null)
        days_since_custom_time     = lookup(lifecycle_rule.value.condition, "days_since_custom_time", null)
        days_since_noncurrent_time = lookup(lifecycle_rule.value.condition, "days_since_noncurrent_time", null)
        noncurrent_time_before     = lookup(lifecycle_rule.value.condition, "noncurrent_time_before", null)
      }
    }
  }
}
