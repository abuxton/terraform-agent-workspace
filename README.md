
# terraform-agent-workspace

This repository contains helper modules and automation for bootstrapping Terraform Enterprise / Terraform Cloud (TFE) resources used by the Terraform MCP server.

## .vscode

The .vscode folder includes configuration for the mcp server `mcp.json` and suitable extensions `extensions.json`

## Example and Backend

An example `backend{}` block is provided for you to populate pointing at your initial HCP Terraform or TFE server, Organization as appropriate. See `./example/default/backend.tf.example`

## Authenticate with the Terraform CLI (terraform)

Terraform's official CLI provides a built-in way to authenticate against Terraform Cloud / Enterprise and generate API tokens for automation.

1. Install the Terraform CLI (1.0+).

2. Use the CLI to login interactively (this will open a browser and create a CLI token):

	```bash
	terraform login
	```

	- The `terraform login` command will prompt for the hostname (use `app.terraform.io` for Terraform Cloud or your enterprise host).
	- It will open a browser where you authenticate and then store a CLI token in `~/.terraform.d/credentials.tfrc.json`.

3. For CI and automation, create a dedicated API token in Terraform Cloud/Enterprise UI:

	- Go to your user settings -> Tokens -> Create an API token.
	- Copy the token and store it in your CI provider's secret manager as `TFE_TOKEN` (do not commit this token).

4. Optionally, export the token locally for testing:

	```bash
	export TFE_TOKEN="<your-token>"
	```

	Or for module variable mapping (less preferred for secrets):

	```bash
	export TF_VAR_tfe_token="<your-token>"
	```

	or using teh included Makefile

	```bash
	make tftoken
	```

## Makefile

The project includes a Makefile for utilities in relation to terraform usage


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

## Generate module documentation with terraform-docs

This repo uses `terraform-docs` to generate module README sections. To populate the docs between the `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` markers, run:

```bash
# From the repository root
terraform-docs markdown . > README.md
# or, if you have a config file at .terraform-docs.yml
terraform-docs -c .terraform-docs.yml markdown . > README.md

```

Note: When run on the root module this will include documentation for all module-level variables and outputs. If you prefer to generate docs for a single module, run `terraform-docs` inside that module's directory.
