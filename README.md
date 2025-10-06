<!-- BEGIN_TF_DOCS -->

# terraform-agent-workspace

This repository contains helper modules and automation for bootstrapping Terraform Enterprise / Terraform Cloud (TFE) resources used by the Terraform MCP server.

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

## Generate module documentation with terraform-docs

This repo uses `terraform-docs` to generate module README sections. To populate the docs between the `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` markers, run:

```bash
# From the repository root
terraform-docs markdown . > README.md
# or, if you have a config file at .terraform-docs.yml
terraform-docs -c .terraform-docs.yml markdown . > README.md
```

Note: When run on the root module this will include documentation for all module-level variables and outputs. If you prefer to generate docs for a single module, run `terraform-docs` inside that module's directory.

<!-- END_TF_DOCS -->