# AGENTS.md — Rules for persisting Terraform HCL (Create / Update)

This file provides agent-facing rules derived from repository `agent-instructions.md` and the Terraform MCP Server usage instructions. Use it when generating or updating Terraform HCL via the MCP server.

## High-level policy
- Persist every create or update that modifies infrastructure as HCL files in the repository.
- Do not apply changes automatically; create a plan and attach it to a PR for human review.
- Keep changes small, well-documented, and reversible where possible.

## Branching & commits
- Create a new branch per logical change using these patterns:
  - feat/<area>-<short>
  - fix/<area>-<short>
- Make one logical change per branch. Keep commits small and focused.
- Use conventional commits (e.g., `feat(module): add network module`).

## Pre-generation checks
## High-level policy

- Persist every create or update that modifies infrastructure as HCL files in the repository.
-
- The target folder for any HCL code is the `./modules/terraform-tfe-resources` module folder.

- Do not apply changes automatically; create a plan and attach it to a PR for human review.

- Keep changes small, well-documented, and reversible where possible.
- Verify provider versions and check for conflicts in the repo.

- Place generated code in appropriate module paths. Required files per module:
  - `main.tf`, `variables.tf`, `outputs.tf`, `README.md` (root module must have README)
  - where possible use `component.tf` or `resource.tf` files as appropriate to aid document intention and context i.e `projects.tf` or `<projectmname>_project.tf` `workspace.tf` or `projectname_workspaces.tf`

## Branching & commits

- Create a new branch per logical change using these patterns:

  - feat/\<area\>-\<short\>

  - fix/\<area\>-\<short\>

- Make one logical change per branch. Keep commits small and focused.

- Use conventional commits (e.g., `feat(module): add network module`).

## Formatting and style
- Run `terraform fmt -recursive` before committing changes.
## Pre-generation checks

Before creating HCL, the agent must:

- Query MCP server for provider docs, registry availability, and style guidance.

- Prefer private registry modules if token is available; otherwise use public registry.

- Verify provider versions and check for conflicts in the repo.
After HCL generation or updates, run the following in order:
1. `terraform init` (do not modify remote backend without human approval)
3. `terraform plan -out=plan.tfplan`
## File layout and naming

- Place generated code in appropriate module paths. Required files per module:

  - `main.tf`, `variables.tf`, `outputs.tf`, `README.md` (root module must have README)

- Recommended: `providers.tf`, `terraform.tf` (`required_version` / `required_providers`), `backend.tf` (root modules), `locals.tf`, `modules/`, and `examples/`.

- For new modules: include an `examples/` directory with a small usage example and a `README.md` describing inputs/outputs and purpose.

## PR requirements
## Formatting and style

- Run `terraform fmt -recursive` before committing changes.

- Adhere to repo style guidelines (two-space indent, equals alignment, argument ordering).
- Module(s) and file paths changed
- `terraform fmt` and `terraform validate` output (or CI step reference)
- `terraform show -no-color plan.tfplan` output or attached `plan.tfplan`
- A checklist (see template below)

### PR checklist (agent should auto-populate)

Save `plan.tfplan` and the output of `terraform show -no-color plan.tfplan` and attach/paste them in the PR.
## Validation and plan (mandatory)

After HCL generation or updates, run the following in order:

1. `terraform init` (do not modify remote backend without human approval)

2. `terraform validate`

3. `terraform plan -out=plan.tfplan`

Save `plan.tfplan` and the output of `terraform show -no-color plan.tfplan` and attach/paste them in the PR.
- [ ] Branch created with appropriate name
- [ ] `terraform fmt -recursive` run
- [ ] `terraform validate` passed
## PR requirements

Every PR that persists HCL must include:

- Clear summary of the change and why it was made

- Module(s) and file paths changed

- `terraform fmt` and `terraform validate` output (or CI step reference)

- `terraform show -no-color plan.tfplan` output or attached `plan.tfplan`

- A checklist (see template below)

## Secrets and state
### PR checklist (agent should auto-populate)

- [ ] Branch created with appropriate name

- [ ] `terraform fmt -recursive` run

- [ ] `terraform validate` passed

- [ ] `terraform plan` created and attached/pasted

- [ ] No secrets committed

- [ ] README updated for new or modified modules

- [ ] Examples added/updated when public API changed

- [ ] Provider and Terraform version constraints verified and documented

## Provider/version handling
- Ensure provider versions are consistent across modules. If a conflict exists, the agent should not make unilateral changes—open an issue/PR proposing alignment and include compatibility notes.
- When necessary, add or update `terraform.tf` that sets `required_version` and `required_providers` with documented rationale.

## Error handling
- If validation or plan fails, include parsed errors and suggested remediation steps in the PR.
- If registry lookups fail, fall back per registry priority and document the fallback in comments.

## Example agent workflow (create module)
1. Query MCP for style and provider info.
2. Create `modules/<name>/main.tf`, `variables.tf`, `outputs.tf`, `README.md`, `examples/`.
3. Run `terraform fmt -recursive`, `terraform init`, `terraform validate`, `terraform plan -out=plan.tfplan`.
4. Commit to `feat/<name>-add` and open PR with plan output and checklist.

## Example agent workflow (update module)
1. Read module/provider versions.
2. Produce minimal diffs (only necessary changes).
3. Run `terraform fmt -recursive`, `terraform init`, `terraform validate`, `terraform plan -out=plan.tfplan`.
4. Commit to `fix/<module>-update` and open PR with plan output and checklist.

---

If you'd like, I can implement the PR template and a CI workflow that runs `fmt`, `validate`, and `tflint` for PRs that touch Terraform files.
