# TODO

## QA Tooling Setup

- [ ] `tflint` per module (QA dim 2, Lint) — Planned.
- [ ] `trivy config` over modules (QA dim 5, Security/SAST) — Planned.
- [ ] terraform-docs check gate wired into CI (QA dim 13).

## Provider dependency

- [ ] Switch from the dev-override (`dev.tfrc`) to a real Registry provider
  reference once `terraform-provider-mxroute` is published to the Terraform
  Registry. Update `provider.tf` version pins and the CI provider-mirror step.
