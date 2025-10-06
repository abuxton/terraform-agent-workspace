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

variable "tfe_skip_tls_verify" {
  description = "Skip TLS verification when connecting to TFE/HCP (use with caution)"
  type        = bool
  default     = false
}
