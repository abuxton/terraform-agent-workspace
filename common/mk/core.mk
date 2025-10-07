# Variables which should be set on the command line
# Makefile: common Terraform CI/CD tasks
# Usage: make <target>
# Targets are idempotent-friendly where possible and intended for CI usage.

# Configurable variables (can be overridden in environment or a .env file)
TF_DIR ?= .
TF_BACKEND_CONFIG ?=
TF_VAR_file ?=

# Default Terraform binary
TF ?= terraform
REPO_TOP ?= $(shell git rev-parse --show-toplevel 2>/dev/null || echo .)
# Helper: load .env if present (works in bash/zsh)
ifneq (,$(wildcard .env))
  include .env
  export
endif

# .PHONEY: check_prereqs

# check_prereqs:
# 	${REPO_TOP}/common/bin/check-make-prereqs

.PHONY: help fmt fmt-check init validate plan show apply destroy tftoken tfdocs tflint tfsec test ci clean

help:
	@echo "Makefile targets:"
	@echo "  fmt         - run 'terraform fmt -recursive'"
	@echo "  fmt-check   - check formatting (fail on unformatted)"
	@echo "  init        - terraform init (supports TF_BACKEND_CONFIG)"
	@echo "  validate    - terraform validate"
	@echo "  plan        - terraform plan (outputs plan.tfplan)"
	@echo "  show        - show plan (requires plan.tfplan)"
	@echo "  apply       - terraform apply plan.tfplan (requires manual approval)"
	@echo "  destroy     - terraform destroy (interactive)"
	@echo "  tftoken     - export tfe_token from credentials"
	@echo "  tfdocs      - generate or update Terraform documentation"
	@echo "  tflint      - run tflint if installed"
	@echo "  tfsec       - run tfsec if installed"
	@echo "  test        - run unit/e2e tests (if present)"
	@echo "  ci          - run non-destructive CI checks (fmt-check, init, validate, tflint, tfsec)"
	@echo "  clean       - cleanup terraform cache/artifacts"

fmt:
	@echo "Running terraform fmt..."
	$(TF) fmt -recursive $(TF_DIR)

fmt-check:
	@echo "Checking terraform fmt..."
	@$(TF) fmt -recursive -check $(TF_DIR)

init:
	@echo "Initializing Terraform..."
	@$(TF) init $(if $(TF_BACKEND_CONFIG),-backend-config=$(TF_BACKEND_CONFIG)) $(TF_DIR)

validate: init
	@echo "Validating Terraform..."
	@$(TF) validate $(TF_DIR)

plan: init
	@echo "Creating terraform plan..."
	@$(TF) plan -out=plan.tfplan $(if $(TF_VAR_file),-var-file=$(TF_VAR_file)) $(TF_DIR)

show:
	@echo "Showing terraform plan..."
	@$(TF) show -no-color plan.tfplan || true

apply:
	@echo "Applying terraform plan (interactive)..."
	@$(TF) apply plan.tfplan

destroy:
	@echo "Destroying resources (interactive)..."
	@$(TF) destroy
tftoken:
	@echo "Terraform token Helper"
	@if [ -f ~/.terraform.d/credentials.tfrc.json ]; then \
	  echo "credentials found in ~/.terraform.d/credentials.tfrc.json. To export the TFE_TOKEN in your shell:"; \
	  echo "for terraform HCP or app.terraform.io use the following:"; \
	  echo "export TFE_TOKEN=\$$(jq -r '.credentials."app.terraform.io".token' < ~/.terraform.d/credentials.tfrc.json)"; \
	  echo "for self-hosted TFE (replace <app.terraform.io> with your server URL):"; \
	else \
	  echo "No credentials file found at ~/.terraform.d/credentials.tfrc.json"; \
	  echo "please login using `terraform login app.terraform.io/eu/<your tfe server>` "; \
	  exit 1; \
	fi
# Optional static checks (if tools installed)
tflint:
	@command -v tflint >/dev/null 2>&1 || { echo "tflint not found, skipping"; exit 0; }
	@echo "Running tflint..."
	@tflint --init && tflint $(TF_DIR)

tfsec:
	@command -v tfsec >/dev/null 2>&1 || { echo "tfsec not found, skipping"; exit 0; }
	@echo "Running tfsec..."
	@tfsec $(TF_DIR)

tfdocs:
	@command -v terraform-docs >/dev/null 2>&1 || { echo "terraform-docs not found, skipping"; exit 0; }
	@echo "Running terraform-docs with config ${REPO_TOP}/.terraform-docs.yml..."
	@terraform-docs -c ${REPO_TOP}/.terraform-docs.yml ${TF_DIR}

# Placeholder for tests (e.g., terratest, kube tests, etc.)
test:
	@echo "Running tests (if configured)..."
	@echo "No tests configured by default"; exit 0

ci: fmt-check init validate tflint tfsec
	@echo "CI checks completed"

clean:
	@echo "Cleaning up terraform artifacts..."
	@rm -f plan.tfplan
	@rm -rf .terraform


# Safety reminder target
remind:
	@echo "IMPORTANT: Do not run 'apply' in CI. Use the plan file and require human approval before applying."
