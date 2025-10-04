# Agent Instructions — Terraform

These instructions are adapted from HashiCorp's Copilot resources (terraform.instructions.md) to guide an AI agent working in this repository.

## Purpose

Help the agent understand goals, constraints, and expected behaviors while making changes to Terraform and related files in this repository. Prioritize safety, idempotence, and minimal-risk edits.

## Repository context

- Repo root: the workspace root contains Terraform-related tooling and editor configuration.

- Focus areas: Terraform HCL files, Sentinel/OPA policies, documentation, and developer tooling (VS Code settings, linters, snippets).

Repository structure expectations (recommended):

- Required in every module/root: `main.tf`, `variables.tf`, `outputs.tf`, and a `README.md` in the root module.
- Recommended additional files: `providers.tf`, `terraform.tf` (for `required_version` and `required_providers`), `backend.tf` (root modules only), `locals.tf`, `modules/`, and `examples/`.

When creating or updating modules, follow the recommended structure and include an example in `examples/` that uses an external source address (not a relative path) for demonstration.

## High-level goals

1. Make safe, incremental changes that are easy for humans to review.

2. Prefer edits that include tests or verifiable checks where practical.

3. Keep changes small and logically scoped; explain why each change is needed.

## Agent operating rules

- Always work on a new branch and open a PR for non-trivial edits. Use descriptive branch names (e.g., `fix/terraform-provider-version`, `feat/terraform-module-readme`).

- If a change could affect infrastructure, do not run or apply Terraform; instead, create or update plans and tests only.

- Do not hard-code secrets, credentials, or provider tokens. Use placeholders and document what secrets are required.

- Add or update documentation (README, module docs) for non-trivial changes.

When adding or updating modules, include:

- A short `README.md` describing purpose, inputs, outputs, and examples.
- Example usage in `examples/` with an external source reference and a simple `main.tf` demonstrating typical variable values.

## File-level guidance

- Terraform HCL (`*.tf`, `*.tfvars`): maintain formatting (`terraform fmt` compatible), prefer explicit provider/version constraints, add comments when inferring intent.

- Sentinel/OPA policies (`*.sentinel`, `*.rego`): include clear test cases or policy examples.

- CI/CD pipeline changes: provide rationale and rollback steps.

- VS Code settings and editor metadata: keep workspace settings non-sensitive and useful to other contributors.

Code formatting and style (key points):

- Run `terraform fmt` before committing; use `terraform fmt -recursive` for multi-module repos.
- Use two-space indentation. Align equals signs for consecutive single-line arguments when it improves readability.
- Order block contents consistently: meta-arguments (`count`, `for_each`), arguments, nested blocks, then `lifecycle` blocks last.
- Separate top-level blocks with a blank line and prefer one blank line between logically distinct groups.
- Consider splitting large `main.tf` into logical files (e.g., `network.tf`, `compute.tf`, `storage.tf`).

## Testing and validation

- Run static checks where possible (e.g., `terraform fmt -check`, `tflint`, `terraform validate`) and include results in the PR description.

- Add small unit-style tests for any helper scripts or policy code.

Terraform-specific testing and CI guidance:

- Add `terraform fmt -check`, `terraform validate`, and `tflint` to CI for any PRs touching `**/*.tf` or `**/*.tfvars` files.
- Use a Terraform testing framework (e.g., `terratest`, built-in module tests) where appropriate and run them in CI.
- Include `variable` validation blocks and automated checks to fail fast with meaningful errors.

## Commit and PR conventions

- Use conventional commit messages: `fix:`, `feat:`, `chore:`, `docs:`.

- PR must contain a short description of the change, test/validation steps, and potential impact.

PR checklist for changes that touch Terraform code:

- [ ] Ran `terraform fmt` and `terraform validate` locally or verified CI will run them.
- [ ] Updated module `README.md` if the public inputs/outputs changed.
- [ ] Updated or added `examples/` for changes to module usage.
- [ ] Verified provider and Terraform version constraints and documented rationale for strict pins.

## Suggested workflow for the agent

1. Read the repo and relevant files. Ask clarifying questions if the goal is ambiguous.

2. Create a small, focused change on a branch. Run linters/formatters locally if possible.

3. Run automated checks and include their output in the PR.

4. Open a PR with explanation and request human review.

## Safety checks

- If a change touches cloud provider code, add an explicit note: "This change may affect infrastructure — do not apply without human review."

- Flag any use of secrets or credentials and refuse to commit them.

State and secrets best practices:

- Never commit `terraform.tfstate` files or `.terraform` directories.
- Use remote backends for state (S3, Azure Storage, Google Cloud Storage, HCP Terraform). Do not change backend configuration or attempt to migrate state without explicit human approval.
- Fetch secrets from external secret managers and mark sensitive variables with `sensitive = true`.

## Communication

- When unsure, ask maintainers for clarification and include links to files or lines.

- Explain non-obvious reasoning in PR descriptions and inline code comments.

## Example tasks

- Bump Terraform provider versions with compatibility notes.

- Add `terraform fmt` and `tflint` checks to CI.

- Refactor a module to accept configurable variables and add README updates.

Additional actionable recommendations inspired by HashiCorp guidance:

- Add a `terraform.tf` to modules that need explicit `required_version` and `required_providers`.
- Create `examples/` for public modules demonstrating recommended usage.
- Introduce a `Makefile` with convenient targets for `fmt`, `validate`, and `lint` (example below).

Makefile example:

```makefile
fmt:
validate:
lint:
  terraform fmt -recursive

validate:
  terraform validate

lint:
  tflint
```

Consider adding a CI job (GitHub Actions or other) that runs the above targets on PRs that change Terraform files.

## Limitations

- The agent should not execute `terraform apply` or modify remote state.

- For operations requiring cloud access, provide instructions and necessary `terraform plan` commands but do not run them.

---

If you'd like, I can:

- Scan the repository for `*.tf` files and produce a report of modules that lack `README.md`, `examples/`, or `terraform.tf` with `required_version`.
- Create a branch and commit suggested CI/Makefile changes with a PR template and checklist.
- Add automated lint/format checks to an existing CI configuration (I can propose a GitHub Actions job).

Which of those should I do next?

---

If you want, I can:

- Tailor this further to your repository's structure (scan for `*.tf` files and add paths).

- Create a branch and commit this file with a short PR template.

- Insert automation commands into `Makefile` or CI configs.

Which would you like me to do next?
