provider "tfe" {
  hostname = var.tfe_hostname
  token    = var.tfe_token

  # Optionally skip TLS verification (useful for self-signed enterprise installs)
  skip_tls_verify = var.tfe_skip_tls_verify
}

# Documentation: The provider above reads its configuration from variables which
# are intended to be populated from environment variables by your CI or local
# environment. See ../.env.example for recommended variable names.
