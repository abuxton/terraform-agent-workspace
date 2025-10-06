variable "tfe_hostname" {
  description = "TFE/HCP hostname (e.g. app.terraform.io or your enterprise hostname)"
  type        = string
  default     = "https://app.terraform.io"
}

variable "tfe_token" {
  description = "Terraform Enterprise (TFE) or HCP Terraform API token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "tfe_ssl_skip_verify" {
  description = "Skip TLS verification when connecting to TFE/HCP (use with caution)"
  type        = bool
  default     = false
}

variable "tfe_organization" {
  description = "Default TFE organization to use when creating resources (optional). Many TFE resources require an organization argument."
  type        = string
  default     = ""
}
