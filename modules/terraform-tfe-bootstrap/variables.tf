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

variable "tfe_workspace_name" {
  description = "Optional default workspace name to use with Terraform Cloud/Enterprise when running CLI operations from this module."
  type        = string
  default     = "terraform-agent-bootstrap"
}

variable "tfe_project" {
  description = "Optional project name to associate with the workspace when using Terraform Enterprise (some installations support workspace projects). If unset, the module or CLI will fall back to \"default\"."
  type        = string
  default     = "default"
}

variable "tfe_workspace_tags" {
  description = "Optional list of tags to apply to the workspace in Terraform Cloud/Enterprise. Provide as a list of strings (e.g. [\"tag1\", \"tag2\"])."
  type        = list(string)
  default     = []
}
