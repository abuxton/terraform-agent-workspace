provider "tfe" {
  hostname = var.tfe_hostname
  token    = var.tfe_token

  # Optionally skip TLS verification (useful for self-signed enterprise installs)
  ssl_skip_verify = var.tfe_ssl_skip_verify
}

# Documentation: The provider above reads its configuration from variables which
# are intended to be populated from environment variables by your CI or local
# environment. See .env.example for recommended variable names.
#
# Note: Many TFE resources (for example, `tfe_workspace`) require an
# `organization` argument. Use `var.tfe_organization` as a default where
# appropriate in resource blocks, or pass organization explicitly in module
# calls. Keep `tfe_organization` optional to avoid surprising changes in
# multi-organization environments.
