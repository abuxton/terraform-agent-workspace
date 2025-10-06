terraform {
  required_version = "~> 1.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.45"
    }
  }

  # Optional: configure Terraform Cloud/Enterprise defaults for this module.
  # The cloud block sets a default hostname and organization so provider-driven
  # workflows and CLI operations can pick up sensible defaults when running
  # inside this module's context.
  cloud {
    hostname     = var.tfe_hostname
    organization = var.tfe_organization
  }
}
