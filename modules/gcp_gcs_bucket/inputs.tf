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
