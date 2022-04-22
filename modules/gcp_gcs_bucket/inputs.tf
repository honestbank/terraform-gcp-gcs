

variable "name" {
  type        = string
  description = "(Required) The name of the bucket."
}

variable "location" {
  type        = string
  description = "(Required) The GCS location"
}

variable "force_destroy" {
  type    = bool
  default = false
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
