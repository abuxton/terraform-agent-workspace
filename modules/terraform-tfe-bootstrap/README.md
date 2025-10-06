# terraform-tfe-bootstrap

Module to bootstrap Terraform Enterprise (TFE) / HCP Terraform resources for an organization.


## Requirements

No special requirements beyond Terraform 1.0+ and the `hashicorp/tfe` provider as declared in `terraform.tf`.

## Usage

Basic example calling this module from a root module:

```hcl
module "tfe_bootstrap" {
  source = "../modules/terraform-tfe-bootstrap"

  # Optionally override defaults
  # tfe_hostname     = "https://app.terraform.io"
  # tfe_organization = "my-org"
}
```

## Authenticating to TFE / HCP with Terraform CLI (Terraform CE)

This module assumes you will authenticate the Terraform CLI to Terraform Cloud (app.terraform.io) or Terraform Enterprise using environment variables or the CLI login flow.

- Environment variables (recommended for CI and automation):

  - For Terraform Cloud (HCP / SaaS):

    ```bash
    export TFE_ADDRESS="https://app.terraform.io"
    export TFE_TOKEN="<your-hcp-or-tfe-token>"
    # Optional: organization
    export TFE_ORGANIZATION="my-org"
    ```

  - For Terraform Enterprise (self-hosted):

    ```bash
    export TFE_ADDRESS="https://tfe.example.com"
    export TFE_TOKEN="<your-enterprise-token>"
    ```

- Terraform CLI login (interactive):

  Use the `terraform login` command to store an API token for the CLI:

  ```bash
  terraform login
  # follow the interactive prompt to generate and store credentials
  ```

Notes:
- CI systems should store `TFE_TOKEN` as a secret and expose it to the runner at build time.
- Avoid committing `TFE_TOKEN` into source control. Instead use `TF_VAR_*` or external secret managers for module variables.

## Using this module with the CLI and provider

When running Terraform commands locally or in CI, ensure the provider sees the correct values.

- Local (TF_VAR approach):

  ```bash
  export TF_VAR_tfe_hostname="$TFE_ADDRESS"
  export TF_VAR_tfe_token="$TFE_TOKEN"
  export TF_VAR_tfe_organization="$TFE_ORGANIZATION"
  terraform init
  terraform validate
  terraform plan -out=plan.tfplan
  terraform show -no-color plan.tfplan
  ```

- Direct provider env approach (alternate):

  The `tfe` provider can read `TFE_TOKEN` and `TFE_ADDRESS` directly from environment variables in many contexts. If you prefer that, you can skip setting `TF_VAR_*` and rely on the provider's native env support.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.45 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tfe_hostname"></a> [tfe\_hostname](#input\_tfe\_hostname) | TFE/HCP hostname (e.g. app.terraform.io or your enterprise hostname) | `string` | `"https://app.terraform.io"` | no |
| <a name="input_tfe_organization"></a> [tfe\_organization](#input\_tfe\_organization) | Default TFE organization to use when creating resources (optional). Many TFE resources require an organization argument. | `string` | `""` | no |
| <a name="input_tfe_ssl_skip_verify"></a> [tfe\_ssl\_skip\_verify](#input\_tfe\_ssl\_skip\_verify) | Skip TLS verification when connecting to TFE/HCP (use with caution) | `bool` | `false` | no |
| <a name="input_tfe_token"></a> [tfe\_token](#input\_tfe\_token) | Terraform Enterprise (TFE) or HCP Terraform API token | `string` | `""` | no |
<!-- END_TF_DOCS -->

## Notes about terraform-docs

This README includes terraform-docs markers (`<!-- BEGIN_TF_DOCS -->` / `<!-- END_TF_DOCS -->`).
Run `terraform-docs` (v0.16+ recommended) in the module directory to populate the `## Inputs`, `## Outputs`, `## Providers`, and `## Requirements` sections automatically.


Example:

```bash
# project root
TF_DIR=./modules/terraform-tfe-bootstrap make tfdocs
# directly
cd modules/terraform-tfe-bootstrap
terraform-docs -c ../../.terraform-docs.yml .
make -f ../../Makefile tfdocs


```

If you'd like, I can run `terraform-docs` and commit the generated documentation during this branch's work (requires `terraform-docs` installed in the environment).
