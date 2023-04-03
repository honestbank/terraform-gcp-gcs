# GCP GCS module

This module will create bucket in GCP with enable server-side encryption and logging by default

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.51.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.7.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.51.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.2 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_kms_crypto_key.google_kms_crypto_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key) | resource |
| [google_kms_crypto_key_iam_binding.google_kms_crypto_key_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_binding) | resource |
| [google_kms_key_ring.google_kms_key_ring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring) | resource |
| [google_storage_bucket.google_storage_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.google_storage_bucket_logging](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [random_id.random_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.time_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_storage_project_service_account.google_storage_project_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_project_service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_event_based_hold"></a> [default\_event\_based\_hold](#input\_default\_event\_based\_hold) | (Optional) Whether or not to automatically apply an eventBasedHold to new objects added to the bucket. | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The GCS location | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the bucket. | `string` | n/a | yes |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | (Optional, Default: 'STANDARD') The Storage Class of the new bucket. Supported values include: STANDARD, MULTI\_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE. | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_customer_managed_key_id"></a> [customer\_managed\_key\_id](#output\_customer\_managed\_key\_id) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->
