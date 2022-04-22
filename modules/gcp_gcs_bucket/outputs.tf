output "id" {
  value = google_storage_bucket.google_storage_bucket.id
}

output "customer_managed_key_id" {
  value = google_kms_crypto_key.google_kms_crypto_key.id
}

output "name" {
  value = google_storage_bucket.google_storage_bucket.name
}
