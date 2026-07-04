# TODO

## QA Tooling Setup

- [x] `tflint` per module (QA dim 2, Lint) — gated in pre-commit + CI.
- [x] `trivy config` over modules (QA dim 5, Security/SAST) — gated in pre-commit + CI.
- [x] terraform-docs check gate (QA dim 13) — `bin/build-docs --check`, gated in pre-commit + CI.

## Provider dependency

- [ ] Switch from the dev-override (`dev.tfrc`) to a real Registry provider
  reference once `terraform-provider-mxroute` is published to the Terraform
  Registry. Update `provider.tf` version pins and the CI provider-mirror step.
