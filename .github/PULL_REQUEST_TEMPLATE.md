# Pull Request Template

## Summary

<!-- Describe the purpose of this PR and what it changes. -->

## Changes

- Which modules/files changed:

## Validation

- terraform fmt: (paste output or `passed`)
- terraform validate: (paste output or `passed`)
- terraform plan: (attach `plan.tfplan` or paste `terraform show -no-color plan.tfplan`)

## Checklist

- [ ] Branch name follows pattern `feat/` or `fix/`
- [ ] `terraform fmt -recursive` run
- [ ] `terraform validate` passed
- [ ] `terraform plan` created and attached/pasted
- [ ] No secrets committed
- [ ] README updated for module changes
- [ ] Examples added/updated when public API changed
- [ ] Provider and Terraform version constraints documented

## Notes for reviewers

- Include any special instructions, approximate impact, or checkpoints to verify.

## Approval

- This PR must be approved by a maintainer before any `terraform apply` or destructive operation is executed.
