terraform {
  required_version = "~> 1.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.45"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
  # NOTE: The Terraform Cloud/Enterprise backend configuration (remote backend)
  # is generated from a template at runtime by the module. This repo includes
  # `template/cloud-backend.tpl` and a `local_file` resource in `main.tf` which
  # writes a `backend.tf` file populated from the module variables. This keeps
  # the backend configuration portable and driven by the module inputs.
}
