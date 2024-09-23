variable "name" {
  type        = string
  description = "(Required) The name of the bucket."
}

variable "location" {
  type        = string
  description = "(Required) The GCS location"
}

variable "force_destroy" {
  type        = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  default     = false
}

variable "storage_class" {
  type        = string
  description = "(Optional, Default: 'STANDARD') The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  default     = "STANDARD"
}

variable "default_event_based_hold" {
  type        = bool
  description = "(Optional) Whether or not to automatically apply an eventBasedHold to new objects added to the bucket."
  default     = false
}

variable "project_id" {
  type        = string
  description = "(Required) Id of the project in which the bucket is created"
}

variable "lifecycle_rules" {
  type = list(object({
    # Object with keys:
    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.
    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.
    action = map(string)

    # Object with keys:
    # - age - (Optional) Minimum age of an object in days to satisfy this condition.
    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.
    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    # - matches_storage_class - (Optional) Comma delimited string for storage class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.
    # - matches_prefix - (Optional) One or more matching name prefixes to satisfy this condition.
    # - matches_suffix - (Optional) One or more matching name suffixes to satisfy this condition.
    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.
    # - custom_time_before - (Optional) A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.
    # - days_since_custom_time - (Optional) The number of days from the Custom-Time metadata attribute after which this condition becomes true.
    # - days_since_noncurrent_time - (Optional) Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object.
    # - noncurrent_time_before - (Optional) Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent.
    condition = map(string)
  }))
  description = "List of lifecycle rules to configure. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches_storage_class should be a comma delimited string."
  default     = []
}

variable "object_versioning_enabled" {
  type        = bool
  description = "If set to true, the bucket will be versioned."
  default     = true
}

variable "retention_lock_enabled" {
  type        = bool
  description = "If set to true, the bucket will be locked and objects in the bucket will be protected from deletion. Note that retention_policy cannot be used with object versioning. They are mutually exclusive."
  default     = false
}

variable "retention_lock_duration_seconds" {
  type        = number
  description = "The duration in seconds that objects in the bucket must be retained and cannot be deleted or replaced. The value must be in between 604800(7 days) and 31536000(365 days)."
  default     = 86400 # 1 day
}

variable "soft_delete_retention_duration_seconds" {
  type        = number
  description = "The duration in seconds that soft-deleted objects in the bucket will be retained and cannot be permanently deleted. Default value is 2678400 (30 days). The value must be in between 604800(7 days) and 7776000(90 days). Note: To disable the soft delete policy on a bucket, This field must be set to 0."
  default     = 2678400
}
